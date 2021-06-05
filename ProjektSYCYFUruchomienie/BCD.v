module bin2bcd(

		 input signed[13:0] bin,

		 output reg[15:0] bcd
	
    );

    
   
   
     reg [3:0] i;   
     reg merr = 0;
     //Double Dabble
     always @(bin)
        begin
				
            bcd = 0; 
            for (i = 0; i < 14; i = i+1) 
            begin
                bcd = {bcd[14:0],bin[13-i]}; 
                      
                if(i < 13 && bcd[3:0] > 4) 
                    bcd[3:0] = bcd[3:0] + 3;
                if(i < 13 && bcd[7:4] > 4)
                    bcd[7:4] = bcd[7:4] + 3;
                if(i < 13 && bcd[11:8] > 4)
                    bcd[11:8] = bcd[11:8] + 3;  
					 if(i < 13 && bcd[15:12] > 4)
                    bcd[15:12] = bcd[15:12] + 3;  
            end
				if(bin<0) bcd=16'b1111111111111010; 
        end     
    assign err= merr;
endmodule
