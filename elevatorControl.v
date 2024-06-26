// ElevatorControl.v
module elevatorControl (
    input wire clk,
    input wire reset,
    input wire [4:0] floor_sensors,
    input wire [4:0] request_buttons,
    input wire [4:0] elevator_buttons,
    output reg dir,
    output reg move
);

    parameter  IDLE = 2'b00;
    parameter  MOVING_UP = 2'b01;
    parameter  MOVING_DOWN = 2'b10;
    parameter STOP = 2'b11;

    reg [1:0] state;
    reg [2:0] current_floor;
    reg [4:0] request_list;
    reg [6:0] timer;
    reg [2:0] priority_queue [0:9]; // ?? ?????? ???? ??????? ??????????
    reg [3:0] head; // ?????? ?? ??
    reg [3:0] tail; // ?????? ?? ??
    reg [3:0] i; // ????? ???? ???? ?????? ??

    initial begin
        head = 4'd0;
        tail = 4'd0;
    end
    always @(request_buttons or  elevator_buttons)begin
        for (i = 0; i < 5; i = i + 1) begin
                if (request_buttons[i] == 1'b1 || elevator_buttons[i] == 1'b1) begin
                    priority_queue[tail] <= i;
                    tail <= (tail + 1) % 10; // ????? ???? ??
                end
            end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            current_floor <= 3'b000;
            request_list <= 5'b00000;
            timer <= 7'b0000000;
            dir <= 1'b0;
            move <= 1'b0;
            head <= 4'd0;
            tail <= 4'd0;
            for (i = 0; i < 10; i = i + 1) begin
                priority_queue[i] <= 3'b000;
            end
        end else begin
            // ????? ???? ??????????? ???? ?? ?? ??????
           /* for (i = 0; i < 5; i = i + 1) begin
                if (request_buttons[i] == 1'b1 || elevator_buttons[i] == 1'b1) begin
                    priority_queue[tail] <= i;
                    tail <= (tail + 1) % 10; // ????? ???? ??
                end
            end*/

            case (state)
                IDLE: begin
                    if (head != tail) begin
                        request_list[priority_queue[head]] <= 1'b1;
                        head <= (head + 1) % 10; // ????? ???? ??
                        if (request_list[current_floor]) begin
                            state <= STOP;
                        end else begin
                            if (current_floor < priority_queue[head]) begin
                                state <= MOVING_UP;
                            end else if (current_floor > priority_queue[head]) begin
                                state <= MOVING_DOWN;
                            end
                        end
                    end
                end
                MOVING_UP: begin
                    dir <= 1'b1;
                    move <= 1'b1;
                    if (floor_sensors[current_floor ]) begin
                        current_floor <= current_floor + 1;
                        if (request_list[current_floor]) begin
                            state <= STOP;
                        end
                    end
                end
                MOVING_DOWN: begin
                    dir <= 1'b0;
                    move <= 1'b1;
                    if (floor_sensors[current_floor ]) begin
                        current_floor <= current_floor - 1;
                        if (request_list[current_floor]) begin
                            state <= STOP;
                        end
                    end
                end
                STOP: begin
                    move <= 1'b0;
                    timer <= timer + 1;
                    if (timer == 100) begin
                        request_list[current_floor] <= 1'b0;
                        timer <= 7'b0000000;
                            state <= IDLE;
                            
                        
                    end
                end
            endcase
        end
    end
endmodule


