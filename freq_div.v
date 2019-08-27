module freq_div(
    input rst,
    input f_cst,
    input [26:0]freq,
    output reg fout 
    );
    
reg [26:0] count;

always@(posedge f_cst or posedge rst)
if(rst)begin
    count <= 0;
    fout <= 0;
end
else if(count == freq) begin
    count <= 0;
    fout <= ~fout;
end
else
    count <= count+1;

endmodule
