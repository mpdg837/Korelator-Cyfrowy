
module przycisk(
	input mode,
	input in,
	input clk,
	output press,
	output spress,
	output rspress
);

reg[17:0] lic = 18'b0;
reg[17:0] nlic = 18'b0;
reg snd = 1'b1;
reg nsnd = 1'b1;

reg switch = 1'b1;
reg nswitch = 1'b1;

always@ ( posedge clk )begin
	
	snd <= nsnd;
	lic <= nlic;
	switch <= nswitch;
end

always@ ( * )begin
	// Pompka przycisku
	nsnd = snd;
	nlic = 8'd0;
	nswitch = switch;
	
	if(in) begin
		
		if(nlic < 18'd25000) begin
			nlic = lic + 1;
		end
	
		if(nlic > 18'd24000) begin
			if( ~snd ) begin
				nswitch = ~switch;
			end
		
			nsnd = 1; 
			
		end
	
	end else
	begin
		if(nlic > 0) begin
			nlic = lic - 1;
		end
		
		if(nlic < 18'd10000) begin
			nsnd = 0;
		end
		
	end
	
	
	if(~mode) begin
		nswitch = nsnd;
	end
end

assign rspress = snd;
assign press = switch;
assign spress = in;

endmodule