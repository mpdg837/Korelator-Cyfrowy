module monitor(
	input clk,
	input signed[13:0] tim,
	input rdy
);

always@(posedge clk)begin
	
	if(tim == 3001 && rdy)begin
		$display("Test zakończył się sukcesem");
	end
end
endmodule
