
module VGA(
   clock,
   switch,
   disp_RGB,
   hsync,
   vsync
);
input  clock;     //ϵͳ����ʱ�� 50MHz
input  [1:0]switch;
output [2:0]disp_RGB;    //VGA��������
output  hsync;     //VGA��ͬ���ź�
output  vsync;     //VGA��ͬ���ź�

reg [9:0] hcount;     //VGA��ɨ��������
reg [9:0]   vcount;     //VGA��ɨ��������
reg [2:0]   data;
reg [2:0]  h_dat;
reg [2:0]   v_dat;

//reg [9:0]   timer;

reg   flag;
wire  hcount_ov;
wire  vcount_ov;
wire  dat_act;
wire  hsync;
wire   vsync;
reg  vga_clk;

parameter hsync_end   = 10'd95,
   hdat_begin  = 10'd0,
   hdat_end  = 10'd783,
   hpixel_end  = 10'd799,
	
   vsync_end  = 10'd0,
   vdat_begin  = 10'd0,
   vdat_end  = 10'd514,
   vline_end  = 10'd524;

	
	//Reloj de VGA

always @(posedge clock)
begin
 vga_clk = ~vga_clk;
end

//************************VGA��������******************************* 
//��ɨ��     
//Reinicio de escritura en la pantalla

always @(posedge vga_clk)
begin
 if (hcount_ov)
  hcount <= 10'd0;
 else
  hcount <= hcount + 10'd1;
end
assign hcount_ov = (hcount == hpixel_end);
//��ɨ��
always @(posedge vga_clk)
begin
 if (hcount_ov)
 begin
  if (vcount_ov)
   vcount <= 10'd0;
  else
   vcount <= vcount + 10'd1;
 end
end
assign  vcount_ov = (vcount == vline_end);



//���ݡ�ͬ���ź���
assign dat_act =    ((hcount >= hdat_begin) && (hcount < hdat_end))
     && ((vcount >= vdat_begin) && (vcount < vdat_end));
assign hsync = (hcount > hsync_end);
assign vsync = (vcount > vsync_end);
assign disp_RGB = (dat_act) ?  data : 3'h00;       



//************************��ʾ���ݴ�����******************************* 
//ͼƬ��ʾ��ʱ������
/*always @(posedge vga_clk)
begin
 flag <= vcount_ov;
 if(vcount_ov && ~flag)
  timer <= timer + 1'b1;
end
*/


////Switches de control
always @(posedge vga_clk)
begin
 case(switch[1:0])
  2'd0: data <= v_dat;      //ѡ��������
  2'd1: data <= h_dat;      //ѡ��������
  2'd2: data <= (v_dat ^ h_dat); //�������̸�
  2'd3: data <= (v_dat ~^ h_dat); //�������̸�
 endcase
end


//pintar en la pantalla los cuadrados
always @(posedge vga_clk)  //����������
begin
 if(hcount < 223)
  v_dat <= 3'h7;      //��   
 else if(hcount < 303)
  v_dat <= 3'h0;   //��
 else if(hcount < 383)
  v_dat <= 3'h7;   //��
 else if(hcount < 463)
  v_dat <= 3'h0;    //��
 else if(hcount < 543)
  v_dat <= 3'h7;   //��
 else if(hcount < 623)
  v_dat <= 3'h0;   //��
 else if(hcount < 703)
  v_dat <= 3'h7;   //�
 else if (hcount<783)
	v_dat<=3'h0;
 else if( hcount<800)
	v_dat<=3'h2;
 else 
  v_dat <= 3'h0;   //��
end

always @(posedge vga_clk)  //����������
begin
 if(vcount < 94)
  h_dat <= 3'h7;        //��
 else if(vcount < 154)
  h_dat <= 3'h0;   //��
 else if(vcount < 214)
  h_dat <= 3'h7;   //��
 else if(vcount < 274)
  h_dat <= 3'h0;    //��
 else if(vcount < 334)
  h_dat <= 3'h7;   //��
 else if(vcount < 394)
  h_dat <= 3'h0;   //��
 else if(vcount < 454)
  h_dat <= 3'h7;   //�
 
 else
  h_dat <= 3'h0;   //��
end

endmodule

