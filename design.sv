// Code your design here
module twelvehourclk(
    input clk,
    input reset,
    input ena,
    output reg pm,
  	output reg [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    
    wire [2:0] ena_hms;
    assign ena_hms={ena&(mm==8'h59)&(ss==8'h59),ena&(ss==8'h59),ena};
    count c1(clk,reset,ena_hms[0],ss[7:0]);
    count c2(clk,reset,ena_hms[1],mm[7:0]);
    
    always @ (posedge clk)
        begin	    
        	if (reset)
            	begin
            		hh=8'h12;
                	pm=0;
            	end
            else
                begin
                    if (ena_hms[2]& (mm[7:0]==8'h59) & (ss[7:0]==8'h59))
                        begin
                            if (hh[7:0]==8'h12)
                                hh=8'h1;
                            else if (hh[7:0]==8'h11)
                                begin
                                    hh=8'h12;
                                    pm=~pm;
                                end
                            else
                                begin
                                    if (hh[3:0]==4'h9)
                                        begin
                                            hh[3:0]=4'h0;
                                            hh[7:4]=hh[7:4]+1;
                                        end
                                    else
                                        hh[3:0]=hh[3:0]+1;
                                end
                        end
                    else
                        hh=hh;
                end
        end
                        
    

endmodule

module count(
    input clk,
    input reset,
    input ena,
    output reg [7:0] q);
    
    always @(posedge clk)
        begin
            if (reset)
                q=0;
            else
                begin
                    if (ena)
                        begin
                            if (q[3:0]==4'h9)
                                begin
                                    if (q[7:4]==4'h5)
                                        q=8'h0;
                                    else
                                        begin
                                            q[3:0]=0;
                                            q[7:4]=q[7:4]+1;
                                        end
                                end
                            else
                                q[3:0]=q[3:0]+1;
                        end
                    else
                        q=q;
                end
            end
endmodule
            