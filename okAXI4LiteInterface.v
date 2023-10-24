`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Columbia University
// Engineer: William Stoy, PhD
// 
// Create Date: 12/16/2022 05:38:48 PM
// Design Name: 
// Module Name: okAXI4LiteInterface
// Project Name: 
// Target Devices: Opal Kelly FPGA Integration / Evaluation / Acceleration Modules
// Tool Versions: 
// Description: Bidirectional AXI4-Lite communication via Opal Kelly FrontPanel IP
// 
// Dependencies: Opal Kelly FrontPanel IP
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module okAXI4LiteInterface
# (
    parameter   ADDR_WIDTH                  = 12,
                //ARUSER_WIDTH                = 0,
                //AWUSER_WIDTH                = 0,
                //BUSER_WIDTH                 = 0,
                DATA_WIDTH                  = 32
                //FREQ_HZ                     = 100800000
                //HAS_BRESP                   = 0,
                //HAS_BURST                   = 0,
                //HAS_CACHE                   = 0,
                //HAS_LOCK                    = 0,
                //HAS_PROT                    = 0,
                //HAS_QOS                     = 0,
                //HAS_REGION                  = 0,
                //HAS_RRESP                   = 0,
                //HAS_WSTRB                   = 0,
                //ID_WIDTH                    = 0,
                //INSERT_VIP                  = 0,
                //MAX_BURST_LENGTH            = 1,
                //NUM_READ_OUTSTANDING        = 1,
                //NUM_READ_THREADS            = 1,
                //NUM_WRITE_OUTSTANDING       = 1,
                //NUM_WRITE_THREADS           = 1,
                //PHASE                       = 0.0,
                //PROTOCOL                    = "AXI4LITE",
                //READ_WRITE_MODE             = "READ_WRITE",
                //RUSER_BITS_PER_BYTE         = 0,
                //RUSER_WIDTH                 = 0,
                //SUPPORTS_NARROW_BURST       = 0,
                //WUSER_BITS_PER_BYTE         = 0,
                //WUSER_WIDTH                 = 0
) (

    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100800000" *)
    input   wire                    okClkIn,
    
    ///////////////////////////////////////
    // OPAL KELLY FRONTPANEL
    // BTPIPEIN
    (* X_INTERFACE_INFO = "opalkelly.com:interface:btpipein:1.0 btpipein_DATA EP_DATAOUT" *)
    input   wire [31:0]             EP_DATAOUT,
    (* X_INTERFACE_INFO = "opalkelly.com:interface:btpipein:1.0 btpipein_DATA EP_READY" *)
    output  reg                     EP_READY,
    (* X_INTERFACE_INFO = "opalkelly.com:interface:btpipein:1.0 btpipein_DATA EP_WRITE" *)
    input   wire                    EP_WRITE,

    /*
    // BTPIPEOUT
    (* X_INTERFACE_INFO = "opalkelly.com:interface:btpipeout:1.0 btpipeout_READ EP_DATAIN" *)
    output  reg [31:0]              EP_DATAIN_DATAIN = 32'd0,
    (* X_INTERFACE_INFO = "opalkelly.com:interface:btpipeout:1.0 btpipeout_READ EP_READY" *)
    output  reg                     EP_READY_DATAIN = 1'b0,
    (* X_INTERFACE_INFO = "opalkelly.com:interface:btpipeout:1.0 btpipeout_READ EP_READ" *)
    input   wire                    EP_READ_DATAIN,
    */
    
    
    // WIREOUT
    (* X_INTERFACE_INFO = "opalkelly.com:interface:wireout:1.0 wireout_READDATA EP_DATAIN" *)
    output  reg [31:0]              EP_DATAIN_WIREOUT = 32'd0,
    
    
    // WIREOUT
    // @todo: remove this. BRESP stands for burst response. Commonly on AXI4-lite slaves this is tied to 0 (OKAY)
    // @todo: or not- it seems that the BRESP is used to indicate the status of the write transaction in the JESD204 example TB
    //(* X_INTERFACE_INFO = "opalkelly.com:interface:wireout:1.0 wireout_BRESP EP_DATAIN" *)
    //output  reg [1:0]               EP_BRESP_WIREOUT = 2'd0,
    
    
    
    ///////////////////////////////////////
    // AXI4LITE INTERFACE
    //(* X_INTERFACE_PARAMETER = "PHASE 0.0,MAX_BURST_LENGTH 1,NUM_WRITE_OUTSTANDING 1,NUM_READ_OUTSTANDING 1,SUPPORTS_NARROW_BURST 0,READ_WRITE_MODE READ_WRITE,BUSER_WIDTH 0,RUSER_WIDTH 0,WUSER_WIDTH 0,ARUSER_WIDTH 0,AWUSER_WIDTH 0,ADDR_WIDTH 32,ID_WIDTH 0,FREQ_HZ 100800000,PROTOCOL AXI4LITE,DATA_WIDTH 32,HAS_BURST 0,HAS_CACHE 0,HAS_LOCK 0,HAS_PROT 0,HAS_QOS 0,HAS_REGION 0,HAS_WSTRB 0,HAS_BRESP 0,HAS_RRESP 0" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 100800000" *)
    output  wire                    m_axi_aclk,
    output  reg                     m_axi_aresetn   = 1'b1,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi AWADDR" *)
    output  reg [ADDR_WIDTH-1:0]    m_axi_awaddr    = {ADDR_WIDTH{1'b0}},   // Write address 
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi AWVALID" *)
    output  reg                     m_axi_awvalid   = 1'b0,                 // Write address valid
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi AWREADY" *)
    input   wire                    m_axi_awready,                          // Write address ready
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi WDATA" *)
    output  reg [DATA_WIDTH-1:0]    m_axi_wdata     = {DATA_WIDTH{1'b0}},   // Write data
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi WSTRB" *)
    output  wire  [DATA_WIDTH/8-1:0] m_axi_wstrb,                           // Write strobes (optional) ------------ HARDCODED FIX SIZE
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi WVALID" *)
    output  reg                     m_axi_wvalid    = 1'b0,                 // Write valid
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi WREADY" *)
    input   wire                    m_axi_wready,                           // Write ready
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi BRESP" *)
    input   wire [1:0]              m_axi_bresp,                            // Write response (optional) =--------- MAYBE HARDCODED? SIZE
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi BVALID" *)
    input   wire                    m_axi_bvalid,                           // Write response valid (optional)=--------- MAYBE HARDCODED? SIZE
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi BREADY" *)
    output  reg                     m_axi_bready    = 1'b0,                 // Write response ready (optional)=--------- MAYBE HARDCODED? SIZE
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi ARADDR" *)
    output  reg [ADDR_WIDTH-1:0]    m_axi_araddr    = 1'b0,                 // Read address
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi ARVALID" *)
    output  reg                     m_axi_arvalid   = 1'b0,                 // Read address valid
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi ARREADY" *)
    input   wire                    m_axi_arready,                          // Read address ready
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi RDATA" *)
    input   wire [DATA_WIDTH-1:0]   m_axi_rdata,                            // Read data
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi RRESP" *)
    input   wire [1:0]              m_axi_rresp,                            // Read response (optional) =--------- MAYBE HARDCODED? SIZE
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi RVALID" *)
    input   wire                    m_axi_rvalid,                           // Read valid
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi RREADY" *)
    output  reg                     m_axi_rready    = 1'b0,                  // Read ready
    
    output  wire                    activity_mon
);

// when the read high is asserted, start counting up to 4
// the first 32 bits transferred are the first 4 bytes, which represents the write address
// the second 32 bits transferred are the write data,
// the third 32 bits transferred are the read address

assign      activity_mon    = m_axi_wvalid | ~m_axi_aresetn;
assign      m_axi_aclk      = okClkIn;

localparam  WORD_LENGTH     = 32;

localparam  STATE_IDLE = 0,
            STATE_RESET = 1,
            STATE_AXI_RXTX = 2;
            
localparam  MAX_RX_WORDS_FROM_OK = 4,
            CLOCK_CYCLES_AXI_RESET = 21; // AXI spec recommends a minimum of 16 axi clock cycles to reset. JESD204 example uses 20
            
reg [3:0] state = STATE_IDLE;
reg [3:0] next_state = STATE_IDLE;
reg     [$clog2(MAX_RX_WORDS_FROM_OK):0]      counter_rx_from_ok;
reg     [$clog2(CLOCK_CYCLES_AXI_RESET):0]    counter_resetting;

reg reset_flag          = 0,
    read_flag           = 0,
    write_flag          = 0,
    write_response_flag = 0,
    read_address_flag   = 0;
    //ok_reading_flag     = 0;

// make the wstrb 4 bits high when the wvalid signal is true
assign m_axi_wstrb = m_axi_wvalid ? {DATA_WIDTH{1'b1}} : {DATA_WIDTH{1'b0}};

localparam  reset_index = 0,
            write_index = 1,
            read_index  = 2;

// state transition logic
always @(*)
begin
    case (state)
        STATE_IDLE:
        begin
            if (counter_rx_from_ok == MAX_RX_WORDS_FROM_OK)
            begin
                if (reset_flag)
                    next_state = STATE_RESET;
                else if (write_flag | read_flag)
                    next_state = STATE_AXI_RXTX;
                else
                    next_state = STATE_IDLE;
            end
            else
                next_state = state;
        end
        
        STATE_RESET:
        begin
            if (counter_resetting == CLOCK_CYCLES_AXI_RESET)
            begin
                if (write_flag | read_flag)
                    next_state = STATE_AXI_RXTX;
                else
                    next_state = STATE_IDLE;
            end
            else
                next_state = state;
        end
        
        STATE_AXI_RXTX:
        begin
            if (~write_flag & ~write_response_flag & ~read_flag)
                next_state = STATE_IDLE;
            else
                next_state = state;
        end
        
        default:
        begin
            next_state = STATE_IDLE;
        end
        
    endcase
end

always @(posedge okClkIn)
begin
    // state flip-flop
    state <= next_state;
end

// output logic
always @(posedge okClkIn)
begin
    case (state)
        STATE_IDLE:
        begin
            if (~EP_WRITE)
            begin
                EP_READY <= 1'b1;
                counter_rx_from_ok <= 0;
            end
            else
            begin
                EP_READY <= 1'b0;
                counter_rx_from_ok  <= counter_rx_from_ok + 1;
            
                case (counter_rx_from_ok)
                    0:
                    begin
                       reset_flag          <= EP_DATAOUT[reset_index];
                       write_flag          <= EP_DATAOUT[write_index];
                       write_response_flag <= EP_DATAOUT[write_index];
                       read_flag           <= EP_DATAOUT[read_index];
                       read_address_flag   <= EP_DATAOUT[read_index];
                    end
                    
                    1: m_axi_awaddr        <= EP_DATAOUT[ADDR_WIDTH-1:0];
                    2: m_axi_wdata         <= EP_DATAOUT[DATA_WIDTH-1:0];
                    3: m_axi_araddr        <= EP_DATAOUT[ADDR_WIDTH-1:0];
                endcase
            end
            
            /*
            if (EP_READY_DATAIN & EP_READ_DATAIN)
                ok_reading_flag <= 1'b1;
                
            if (ok_reading_flag & ~EP_READ_DATAIN)
            begin
                ok_reading_flag <= 1'b0;
                EP_READY_DATAIN <= 1'b0;
                EP_DATAIN_DATAIN <= 32'd0;
            end
            */
            
            counter_resetting   <= 0;
            m_axi_aresetn       <= 1'b1;
            m_axi_awvalid       <= 1'b0;
            m_axi_wvalid        <= 1'b0;
            m_axi_arvalid       <= 1'b0;
            m_axi_rready        <= 1'b0;
            m_axi_bready        <= 1'b0;
            //m_axi_wstrb         <= 4'h0;
        end
        
        STATE_RESET:
        begin
            counter_resetting   <= counter_resetting + 1;
            
            if (counter_resetting == CLOCK_CYCLES_AXI_RESET)
            begin
                m_axi_aresetn   <= 1'b1;
                reset_flag      <= 1'b0;
            end
            else
                m_axi_aresetn   <= 1'b0;
            
            counter_rx_from_ok  <= 0;
            m_axi_awvalid       <= 1'b0;
            m_axi_wvalid        <= 1'b0;
            m_axi_arvalid       <= 1'b0;
            m_axi_rready        <= 1'b0;
            m_axi_bready        <= 1'b0;
            //m_axi_wstrb         <= 4'h0;
            
            //EP_READY_DATAIN     <= 1'b0;
            
            //EP_DATAIN_DATAIN    <= 32'd0;
            //EP_BRESP_WIREOUT    <= 32'd0;
        end
        
        STATE_AXI_RXTX:
        begin
            // handle write address flags
            if (m_axi_awvalid & m_axi_awready)
                m_axi_awvalid <= 1'b0;
            else
                m_axi_awvalid <= write_flag;
            
            // handle write flags
            if (m_axi_wvalid & m_axi_wready)
            begin
                m_axi_wvalid <= 1'b0;
                write_flag   <= 1'b0;
                //m_axi_wstrb  <= 4'h0;
            end
            else
            begin
                m_axi_wvalid <= write_flag;
                //m_axi_wstrb  <= write_flag ? 4'hf : 4'h0;
            end
            // handle write response flags
            if (m_axi_bvalid & m_axi_bready)
            begin
                m_axi_bready        <= 1'b0;
                write_response_flag <= 1'b0;
                //EP_BRESP_WIREOUT    <= m_axi_bresp;
            end
            else
                m_axi_bready <= write_response_flag;
            
            // handle read address flags
            if (m_axi_arvalid & m_axi_arready)
            begin
                m_axi_arvalid       <= 1'b0;
                read_address_flag   <= 1'b0;
            end
            else
                m_axi_arvalid <= read_address_flag;
            
            // handle read flags
            if (m_axi_rvalid)
            begin
                if (~m_axi_rready)
                begin
                    m_axi_rready        <= 1'b1;
                    
                    //EP_DATAIN_DATAIN    <= m_axi_rdata;
                    //EP_READY_DATAIN     <= 1'b1;
                    EP_DATAIN_WIREOUT   <= m_axi_rdata;
                    
                    read_flag           <= 1'b0;
                end
                else
                begin 
                    m_axi_rready <= 1'b0;
                end
            end
            else
                m_axi_rready <= 1'b0;
                
                
            m_axi_aresetn <= 1'b1;
        end
    endcase
end
    
endmodule
