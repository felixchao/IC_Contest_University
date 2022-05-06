`timescale 1ns/10ps
`define CYCLE      50.0  
`define End_CYCLE  1000000
`define PATTERN    "test.data"
`define GOLDEN     "golden.data"

`include "Queue.v"

module tb_Queue;

    // Register
    logic clk = 0;
    logic rst = 0;
    logic [1:0] operation;
    logic [7:0] in;
    logic [7:0] out;
    logic       empty;
    logic       full;

    // Test Module
    Queue Queue
    (
        .clk(clk), 
        .rst(rst), 
        .operation(operation), 
        .in(in),
        .out(out),
        .empty(empty),
        .full(full)
    );

    // System Clock
    always 
    begin 
        #(`CYCLE/2) clk = ~clk; 
    end
    // Initialization
    initial 
    begin
        $display("----------------------");
        $display("-- Simulation Start --");
        $display("----------------------");
        rst = 1'b1; 
        #(`CYCLE * 2);  
        rst = 1'b0;
    end

    integer fd;
    integer fg;
    logic [22:0] cycle=0;
    // Check whether in forever loop
    always @(posedge clk) 
    begin
        cycle = cycle + 1;
        if (cycle > `End_CYCLE) 
        begin
            $display("--------------------------------------------------");
            $display("-- Failed waiting valid signal, Simulation STOP --");
            $display("--------------------------------------------------");
            $fclose(fd);
            $finish;
        end
    end
    // Read test data
    initial 
    begin
        fd = $fopen(`PATTERN,"r");
        if (fd == 0) 
        begin
            $display ("pattern handle null");
            $finish;
        end
    end
    // Read Golden data
    initial 
    begin
        fg = $fopen(`GOLDEN,"r");
        if (fg == 0) 
        begin
            $display ("golden handle null");
            $finish;
        end
    end

    integer pass = 0;
    integer fail = 0;
    integer test = 0;
    string testLine;
    integer golden = 0;
    string goldenLine;
    string information;
    integer testNumber = 0;

    logic [7:0] GOut;
    logic       GEmpty;
    logic       GFull;
    
    always @(negedge clk)
    begin
        if (rst)
        begin
            operation = 0;
            in = 0;
        end
        else if (!$feof(fd) && !$feof(fg))
        begin
            test = $fgets (testLine, fd);
            if (test != 0)
            begin
                while (testLine.substr(0, 1) == "//")
                begin
                    // $display("%s", testLine);
                    test = $fgets (testLine, fd);
                end
                test = $sscanf(testLine, "%d %d", operation, in);
                // $display("Operation: %d, Input: %d", operation, in);
            end
            golden = $fgets (goldenLine, fg);
            if (golden != 0)
            begin
                while (goldenLine.substr(0, 1) == "//")
                begin
                    // $display("%s", goldenLine);
                    information = goldenLine;
                    golden = $fgets (goldenLine, fg);
                end
                testNumber = testNumber + 1;
                golden = $sscanf(goldenLine, "%d %d %d", GOut, GEmpty, GFull);
                if ((out == GOut) && (empty == GEmpty) && (full == GFull)) 
                begin
                    pass = pass + 1;
                end
                else
                begin
                    $display("\n[Test %2d]\n\t%s\tOutput = %d, Empty = %d, Full = %d\n\tExpect Output = %d, Empty = %d, Full = %d",
                                testNumber, information, out, empty, full, GOut, GEmpty, GFull);
                    fail = fail + 1;
                end
            end
        end
        else
        begin
            $fclose(fd);
            $fclose(fg);
            if (fail === 0)
            begin
                $display("\n");
                $display("\n");
                $display("        ****************************    _._     _,-'\"\"`-._        ");
                $display("        **  Congratulations !!    **   (,-.`._,'(       |\\`-/|     ");
                $display("        **  Simulation1 PASS!!    **       `-.-' \\ )-`( , o o)     ");
                $display("        ****************************             `-    \\`_`\"'-    ");
                $display("\n");
            end
            else
            begin
                $display("\n");
                $display("\n");
                $display("        ****************************         |\\      _,,,---,,_     ");
                $display("        **  OOPS!!                **   ZZZzz /,`.-'`'    -.  ;-;;,_  ");
                $display("        **  Simulation1 Failed!!  **        |,4-  ) )-,_. ,\\ (  `'-'");
                $display("        ****************************       '---''(_/--'  `-'\\_)     ");
                $display("         Totally has %d errors                                       ", fail); 
                $display("\n");
            end
            result(fail, (pass + fail));
            $finish;
        end
    end

    task result;
        input integer err;
        input integer num;
        integer rf;
        begin
            rf = $fopen("result.txt", "w");
            $fdisplay(rf, "%d,%d", num - err, num);
        end
    endtask
endmodule