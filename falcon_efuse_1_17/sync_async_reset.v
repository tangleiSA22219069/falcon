module sync_async_reset(
    input clk           ,
    input rst_n         ,
    output reg rst_n_s
    );
    reg mid_rst;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rst_n_s <= 1'b0     ;
            mid_rst <= 1'b0     ;
        end
        else begin
            mid_rst <= 1'b1     ;
            rst_n_s <= mid_rst  ;
        end        
    end

endmodule