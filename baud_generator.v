//optional can use in top module also.
module baud_generator(input clk,tx,rx);
  reg[12:0] tx_counter;
  reg[9:0] rx_counter;
  
  always@(posedge clk)
    begin
      if(tx_counter==20833)
        tx_counter=0;
      else
        tx_counter=tx_counter+1'b1;
    end
  
  always@(posedge clk)
    begin
      if(rx_counter==2604)
        rx_counter=0;
      else
        rx_counter=rx_counter+1;
    end
  assign tx=(tx_counter=0)?1'b1:1'b0;
  assign rx=(rx_counter=0)?1'b1:1'b0;
endmodule
