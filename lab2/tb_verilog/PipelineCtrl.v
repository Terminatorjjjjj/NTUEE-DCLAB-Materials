module PPForward(
	input      clk,
	input      rst,
	input      src_rdy,
	output reg src_ack,
	output reg dst_rdy,
	input      dst_ack
);

reg dst_rdy_w;
always@* begin
	src_ack = src_rdy && (dst_ack || !dst_rdy);
	dst_rdy_w = src_rdy || (dst_rdy && !dst_ack);
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		dst_rdy <= 1'b0;
	end else if (dst_rdy != dst_rdy_w) begin
		dst_rdy <= dst_rdy_w;
	end
end

endmodule

//////////

module PPForwardLoopIn(
	input      clk,
	input      rst,
	input      loop_done,
	input      src_rdy,
	output reg src_ack,
	output reg dst_rdy,
	input      dst_ack
);

reg dst_rdy_w;
always@* begin
	src_ack = src_rdy && (dst_ack || !dst_rdy);
	dst_rdy_w = (src_rdy && loop_done) || (dst_rdy && !dst_ack);
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		dst_rdy <= 1'b0;
	end else if (dst_rdy != dst_rdy_w) begin
		dst_rdy <= dst_rdy_w;
	end
end

endmodule

//////////

module PPForwardLoopOut(
	input      clk,
	input      rst,
	input      loop_done,
	input      src_rdy,
	output reg src_ack,
	output reg dst_rdy,
	input      dst_ack
);

parameter INSTANT_ACK = 1;

reg dst_rdy_w;
always@* begin
	src_ack = src_rdy && ((INSTANT_ACK != 0) && loop_done && dst_ack || !dst_rdy);
	dst_rdy_w = src_rdy || (dst_rdy && !dst_ack && !loop_done);
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		dst_rdy <= 1'b0;
	end else if (dst_rdy != dst_rdy_w) begin
		dst_rdy <= dst_rdy_w;
	end
end

endmodule
