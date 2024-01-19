module clk_div #(parameter DIV_CLK = 1)(
    input clk           ,
    input rst_n         ,
    output reg clk_div_r
    );
    
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 3'd0;
        else if(cnt==DIV_CLK-1 )
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'b1;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clk_div_r <= 1'b1;
        else if(cnt==DIV_CLK-1 )
            clk_div_r <= ~clk_div_r;
    end
//    reg clk_div_r;

//    always @(posedge clk or negedge rst_n)begin
//        if(!rst_n)
//            clk_div_r <= 1'b1       ;
//        else    
//            clk_div_r <= ~clk_div_r ;
//    end

endmodule