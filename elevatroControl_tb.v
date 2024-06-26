// ElevatorControl_tb.v (Testbench)
module elevatorControl_tb;
    reg clk;
    reg reset;
    reg [4:0] floor_sensors;
    reg [4:0] request_buttons;
    reg [4:0] elevator_buttons;
    wire dir;
    wire move;

    elevatorControl uut (
        .clk(clk),
        .reset(reset),
        .floor_sensors(floor_sensors),
        .request_buttons(request_buttons),
        .elevator_buttons(elevator_buttons),
        .dir(dir),
        .move(move)
    );

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        floor_sensors = 5'b00000;
        request_buttons = 5'b00000;
        elevator_buttons = 5'b00000;

        // Apply reset
        reset = 1;
        #10 reset = 0;

        // Test scenario 1: Request from floor 1
        request_buttons = 5'b00010;
        #20 request_buttons = 0;
        #20
        floor_sensors = 5'b00001;
        #20
        request_buttons =5'b10000;
        #5 request_buttons=0;
        floor_sensors = 5'b00010;
        #200
        floor_sensors = 5'b00100;
        #20
        floor_sensors = 5'b01000;
        #20
        floor_sensors = 5'b10000;
        #1000;

        
        // End simulation
        $stop;
    end

    always #1 clk = ~clk; // Clock generation
endmodule