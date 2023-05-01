`timescale 1ns/10ps
`define	simulation_time	300000000
`define	cycle_time	8
`define sdf_file "./TPA_syn.sdf"

`define pat "./Pattern_sti.dat"
`define exp "./Pattern_exp.dat"
module	testfixture;

reg	[15:0]	PAT	[0:255];
reg	[15:0]	EXP	[0:255];

reg	clk = 0;
reg	reset_n;

wire 	SCL;
wire 	SDAi;
reg	SDAoe; 
reg	SDAo;
pullup(SDA);
assign SCL = clk;
assign SDA = SDAoe ? SDAo : 1'bz;
assign SDAi = SDA;

reg	cfg_req;
reg	cfg_cmd;
reg	[7:0]	cfg_addr;
wire	cfg_rdy;
wire	[15:0]	cfg_rdata;
reg	[15:0]	cfg_wdata;

always #(`cycle_time/2) clk = ~clk; 

initial $readmemh(`pat, PAT);
initial $readmemh(`exp, EXP);


reg	[15:0] 	register_spaces_data;

reg	check_result_flag;
reg tws_rdout;


TPA u_TPA( .clk(clk), .reset_n(reset_n),
		.SCL(SCL), .SDA(SDA),
		.cfg_req(cfg_req), .cfg_rdy(cfg_rdy), .cfg_cmd(cfg_cmd), .cfg_addr(cfg_addr), .cfg_wdata(cfg_wdata), .cfg_rdata(cfg_rdata)  );



`ifdef SDF
	initial $sdf_annotate(`sdf_file, u_TPA);
`endif


integer i, j;

reg	[15:0] rdata1 ;
reg	[15:0] rdata2 ;
reg	[15:0] wdata1 ;
reg	[15:0] wdata2 ;

reg	[15:0]	exp_pat;

integer pass6_cnt, err6_cnt, err1_cnt, err2_cnt, err3_cnt, err4_cnt, err5_cnt;

initial begin
reset_n = 1;
cfg_req = 0;
SDAoe = 0;
SDAo = 1;
check_result_flag = 0;
cfg_req = 0;
cfg_cmd = 0;
cfg_addr = 0;
cfg_wdata = 0;
tws_rdout = 0;

#1;  reset_n = 0;
#(`cycle_time*3); #1; reset_n = 1;
$display(" ----------------------------------------------------------------------");
$display("TEST START !!!");
$display(" ----------------------------------------------------------------------");
#(`cycle_time*0.25);

//..................................................................................
$display("  ");
$display(" Stage 1. Register Interface Master [ WRITE ] Test ...");  $display("  ");
	for (i=0; i <= 31; i=i+1) begin
		wdata1 = PAT[i];
		cfg_write(i, wdata1);
	end
#(`cycle_time*1);
$display(" Stage 1. Result Check ..."); $display("  ");
	check_result_flag = 1;
	check_result(1, 0, 31, err1_cnt); $display("  "); $display(" ------------------------------------ ");
	check_result_flag = 0;
	
//.................................................................................	
#(`cycle_time*99);

$display(" Stage 2. Register Interface Master [ READ + WRITE ] Test ..."); $display("  ");
	for (i=0; i <= 31; i=i+1) begin
		cfg_read(i, rdata1);
		cfg_write(63-i, rdata1);
	end
#(`cycle_time*1);
$display(" Stage 2. Result Check ..."); $display("  ");
	check_result_flag = 1;
	check_result(2, 32, 63, err2_cnt); $display("  "); $display(" ------------------------------------ ");
	check_result_flag = 0;
	
//.................................................................................		
#(`cycle_time*99);

$display(" Stage 3. Two-Wire Protocol Slaver [ WRITE ] Test ..."); $display("  ");
	for (i=0; i <= 31; i=i+1) begin
		wdata2 = PAT[64+i];
		tws_write(64+i, wdata2);
	end
#(`cycle_time*1);	
$display(" Stage 3. Result Check ..."); $display("  ");
	check_result_flag = 1;
	check_result(3, 64, 95, err3_cnt); $display("  "); $display(" ------------------------------------ ");
	check_result_flag = 0;
	
//.................................................................................		
#(`cycle_time*99);

$display(" Stage 4. Two-Wire Protocol Slaver [ READ + WRITE ] Test ..."); $display("  ");
	for (i=0; i <= 31; i=i+1) begin
		tws_read(64+i, rdata2);
		tws_write(127-i, rdata2);
	end
#(`cycle_time*1);
$display(" Stage 4. Result Check ..."); $display("  ");
	check_result_flag = 1;
	check_result(4, 96, 127, err4_cnt); $display("  "); $display(" ------------------------------------ ");
	check_result_flag = 0;
	
//.................................................................................	
#(`cycle_time*100);

$display(" Stage 5. RIM and TWS concurrently [ READ + WRITE ] Test ..."); $display("  ");
	for (i=0; i <= 127; i=i+1) begin
		if(((i+1)%2) == 1) fork
			cfg_write(128+i, PAT[128+i]);
			tws_write(255-i, PAT[255-i]);
		join
		else fork
			begin
				cfg_read(127+i, rdata1);
				cfg_write(128+i, rdata1);
			end
			begin
				tws_read(256-i, rdata2);
				tws_write(255-i, rdata2);
			end
		join
	end
#(`cycle_time*1);
$display(" Stage 5. Result Check ..."); $display("  ");
	check_result_flag = 1;
	check_result(5, 128, 255, err5_cnt); $display("  "); $display(" ------------------------------------ ");
	check_result_flag = 0;
	
//.................................................................................	
#(`cycle_time*100);


$display(" Stage 6. Arbiter [ WRITE ] Test ..."); $display("  ");

$display(" Stage 6-1. Arbiter [ WRITE ] Test ..."); $display("  ");
pass6_cnt = 0; err6_cnt = 0;
for (i=255; i>=248; i=i-1) begin
fork
	tws_write(i, i);  // golden
	@(posedge clk)  cfg_write(i, 255-i);
join
end
#(`cycle_time*1); check_result_flag = 1;
for (i=255; i>=248; i=i-1) begin
	cfg_read(i, register_spaces_data);
	if(register_spaces_data === 255-i ) pass6_cnt = pass6_cnt + 1;
	else begin 
	err6_cnt = err6_cnt + 1;
	exp_pat = 255-i;
	$display(" Pattern 6-1 at address %d Fail!, expected result is %h, but the responsed result is %h", i, exp_pat, register_spaces_data);
	end
end
if(err6_cnt !== 0) $display(" Stage 6-1. FAIL!, There are %d error data in register spaces", err6_cnt);
check_result_flag = 0;
//.................................................................................

#(`cycle_time*100);
$display(" Stage 6-2. Arbiter [ WRITE ] Test ..."); $display("  ");
pass6_cnt = 0; err6_cnt = 0;
for (i=255; i>=248; i=i-1) begin
fork
	tws_write(i, i);
	cfg_write(i, 255-i);
join
end
#(`cycle_time*1); check_result_flag = 1;
for (i=255; i>=248; i=i-1) begin
	cfg_read(i, register_spaces_data);
	if(register_spaces_data === i ) pass6_cnt = pass6_cnt + 1;
	else begin 
	err6_cnt = err6_cnt + 1;
	exp_pat = i;
	$display(" Pattern 6-2 at address %d Fail!, expected result is %h, but the responsed result is %h", i, exp_pat, register_spaces_data);
	end
end
if(err6_cnt !== 0) $display(" Stage 6-2. FAIL!, There are %d error data in register spaces", err6_cnt);
check_result_flag = 0;
//.................................................................................


#(`cycle_time*100);
$display(" Stage 6-3. Arbiter [ WRITE ] Test ..."); $display("  ");
pass6_cnt = 0; err6_cnt = 0;
for (i=255; i>=248; i=i-1) begin
fork
	tws_write(i, i);
	@(posedge clk) @(posedge clk) cfg_write(i, 255-i);
join
end
#(`cycle_time*1); check_result_flag = 1;
for (i=255; i>=248; i=i-1) begin
	cfg_read(i, register_spaces_data);
	if(register_spaces_data === 255-i ) pass6_cnt = pass6_cnt + 1;
	else begin 
	err6_cnt = err6_cnt + 1;
	$display(" Pattern 6-3 Fail!, expected result is %h, but the responsed result is %h", 255-i, register_spaces_data);
	end
end
if(err6_cnt !== 0) $display(" Stage 6-3. FAIL!, There are %d error data in register spaces", err6_cnt);
check_result_flag = 0;	
//.................................................................................
	
#(`cycle_time*100);

if ((err1_cnt===0)&& (err2_cnt===0)&& (err3_cnt===0)&& (err4_cnt===0)&& (err5_cnt===0)&& (err6_cnt===0) )  begin
            $display("\n-----------------------------------------------------\n");
            $display("Congratulations! All data have been generated successfully!\n");
            $display("-------------------------PASS------------------------\n");
end

$finish;
	
end

initial begin
#(`simulation_time);
$display("\n-----------------------------------------------------\n");
$display("The simulation can't be terminated properly! Please correct your code !! \n") ;
$display("-------------------------------------------------------\n");
$finish;
end


//==============================================================================================================
//================================= WF D U M P ====================================================================

`ifdef FSDB
	initial begin
		$fsdbDumpfile("TPA.fsdb");
		$fsdbDumpMDA(u_TPA);
		$fsdbDumpvars("+all");
	end
`endif

`ifdef VCD
	initial begin
		$dumpfile("TP_arbiter.vcd");
		$dumpvars;
	end
`endif

//==============================================================================================================
//================================= T A S K ====================================================================

task check_result;
input	[2:0]	stage;
input	integer head;
input	integer tail;
output	integer	err_cnt;
integer pass_cnt;
integer i;
begin
pass_cnt = 0; err_cnt = 0;
for (i = head; i<=tail; i=i+1) begin
		cfg_read(i, register_spaces_data);
		if (register_spaces_data === EXP[i])
			pass_cnt = pass_cnt + 1;
		else begin
			err_cnt = err_cnt + 1;
			$display(" Pattern %d at address %d Fail!, expected result is %h, but the responsed result is %h", i, i, EXP[i], register_spaces_data);
			end
	end
	if (err_cnt !== 0) 
	$display(" Stage %d . FAIL!, There are %d error data in register spaces", stage, err_cnt);
	else
	$display(" Stage %d . PASS!", stage);
end
endtask


task cfg_write;
input	[7:0] 	addr;
input	[15:0]	wdata;
integer 	i;
begin
	@(posedge clk); #1; 
		cfg_req = 1; cfg_cmd = 1;
		cfg_addr = addr;
		cfg_wdata = wdata;
		wait(cfg_rdy&cfg_req);
	@(posedge clk); #1; 
		cfg_req = 0;
		cfg_cmd = 0;
		wait(cfg_rdy);
		wait(!cfg_rdy);
end
endtask


task cfg_read;
input	[7:0] 	addr;
output	[15:0]	rdata;
integer 	i;
begin
	@(posedge clk); #1; 
		cfg_req = 1; cfg_cmd = 0;
		cfg_addr = addr;
		wait(cfg_rdy&cfg_req);
	@(posedge clk); #1;
		cfg_req = 0;
		cfg_cmd = 0;
		wait(cfg_rdy);
		@(negedge clk); #1;
		if (cfg_rdy)
			rdata = cfg_rdata;
		wait(!cfg_rdy);
		
end
endtask


task tws_write; 
input	[7:0] addr;
input	[15:0] wdata;
integer i; 
begin
	SDAoe = 1;
 	@(posedge SCL); #1;
  		SDAo = 1;
  	@(posedge SCL); #1;
  		SDAo = 0;
  	@(posedge SCL); #1;
  		SDAo = 1;
	for (i=0; i<=7; i=i+1) begin
		@(posedge SCL); #1;
			SDAo = addr[i];
	end
	for (i=0; i<=15; i=i+1) begin
		@(posedge SCL); #1;
			SDAo = wdata[i];
	end
	@(posedge SCL); #1;
		SDAo = 1;
end
endtask



task tws_read;
input	[7:0] addr;
output [15:0] rdata;
integer i;
begin
	SDAoe = 1;
 	@(posedge SCL); #1;
  		SDAo = 1;
  	@(posedge SCL); #1;
  		SDAo = 0;
  	@(posedge SCL); #1;
  		SDAo = 0;
	for (i=0; i<=7; i=i+1) begin
		@(posedge SCL); #1;
			SDAo = addr[i];
	end
	@(posedge SCL); #1;
		SDAo = 1;
	@(posedge SCL); #1;
		SDAoe = 0;       // TAR 
	@(negedge SCL); #1;      // TAR 
		wait(SDA == 1); // TAR 
	@(negedge SCL); #1;       
		wait(SDAi == 1); 
	@(negedge SCL); #1;
		wait(SDAi == 0); #1;
	for(i=0; i<=15; i=i+1) begin
		@(negedge SCL); #1;
		tws_rdout = 1;
		rdata[i] = SDAi;
	end
	tws_rdout = 0;
	@(negedge SCL); #1;
	
		wait(SDAi == 1);
	@(posedge SCL); #1;
		SDAoe = 1;	// TAR END
	@(posedge SCL); #1;
		SDAo = 1;	
end
endtask




endmodule
