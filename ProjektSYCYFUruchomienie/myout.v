module myOut(
	input ena,
	input rst,
	input clk,
	input signed[13:0] in,
	input detect,
	
	output rdy,
	output signed[13:0] out
);

reg[13:0] n_out;
reg[13:0] r_out;

reg r_rdy;
reg n_rdy;

always@(posedge clk, posedge rst)begin
	
	if(rst) begin
		r_out <= 0;
		r_rdy <= 0;
	end else if(ena) begin
		r_out <= n_out;
		r_rdy <= n_rdy;
	end
	
end

always@(*)begin
	n_rdy = r_rdy;
	n_out = r_out;
	
	if(detect) begin
		n_out = in;
		n_rdy = 1;
	end

end

assign out = n_out;
assign rdy = n_rdy;

endmodule
