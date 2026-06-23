package RAM_seqs;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import seq_item_pkg::*;

  class RAM_reset_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(RAM_reset_seq)

    RAM_seq_item r_seq_item;

    function new(string name = "RAM_reset_seq");
      super.new(name);
    endfunction

    task body();
        repeat(2) begin
            r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
            start_item(r_seq_item);

            r_seq_item.constraint_mode(0);
            assert(r_seq_item.randomize() with { r_seq_item.rst_n == 0; r_seq_item.din[9:8] == 2'b00;});
    
            finish_item(r_seq_item);
        end
    endtask
  endclass : RAM_reset_seq


  class RAM_write_only_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(RAM_write_only_seq)

    RAM_seq_item r_seq_item;

    function new(string name = "RAM_write_only_seq");
      super.new(name);
    endfunction

    task body();
      repeat (1000) begin
        r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
        start_item(r_seq_item);
        r_seq_item.constraint_mode(0);
            r_seq_item.c_rx.constraint_mode(1);
            r_seq_item.c_rst.constraint_mode(1);
            r_seq_item.c_write_only.constraint_mode(1);
        assert(r_seq_item.randomize());
        finish_item(r_seq_item);
      end
    endtask
  endclass : RAM_write_only_seq


  class RAM_read_only_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(RAM_read_only_seq)

    RAM_seq_item r_seq_item;
    

    function new(string name = "RAM_read_only_seq");
      super.new(name);
    endfunction

    task body();
        repeat(2) begin 
            r_seq_item = RAM_seq_item::type_id::create("r_seq_item"); 
            start_item(r_seq_item);
            
            r_seq_item.constraint_mode(0);
            if (r_seq_item.prev_op == 2'b00)begin // Read data => Read address 
                assert (r_seq_item.randomize() with {din[9:8] == 2'b01;}); 
            end 
            else if (r_seq_item.prev_op == 2'b01) begin //Read address => Read data 
                assert (r_seq_item.randomize() with {din[9:8] == 2'b10;}); 
            end 
            finish_item(r_seq_item); 
        end
        repeat(10000) begin
            r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
            start_item(r_seq_item);

            r_seq_item.constraint_mode(0);
            r_seq_item.c_rx.constraint_mode(1);
            r_seq_item.c_rst.constraint_mode(1);
            r_seq_item.c_read_only.constraint_mode(1); 

            if (r_seq_item.prev_op == 2'b10) begin  // Read address => Read data 
                assert (r_seq_item.randomize() with {din[9:8] == 2'b11;});
            end
            else begin      // Read data (2'b11) => Read address 
                assert (r_seq_item.randomize());
            end
            
            finish_item(r_seq_item);
        end
    endtask 
  endclass : RAM_read_only_seq


  class RAM_read_write_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(RAM_read_write_seq)

    RAM_seq_item r_seq_item;

    function new(string name = "RAM_read_write_seq");
      super.new(name);
    endfunction

    task body();
  
repeat(10000) begin
            r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
            start_item(r_seq_item);

            r_seq_item.constraint_mode(0);
            r_seq_item.c_rx.constraint_mode(1);
            r_seq_item.c_rst.constraint_mode(1);
            r_seq_item.c_read_write.constraint_mode(1);
            
            case (r_seq_item.prev_op)
                //After Write Address operation
                2'b00 : assert (r_seq_item.randomize() with {r_seq_item.din[9:8] dist { [2'b00:2'b01] := 100};});
                //After Write Data operation
                2'b01 : assert (r_seq_item.randomize() with {r_seq_item.din[9:8] dist { 2'b00 := 40, 2'b10 := 60};});
                //After Read Address operation
                2'b10 : assert (r_seq_item.randomize() with {r_seq_item.din[9:8] dist { [2'b10:2'b11] := 100};});
                //After Read Data operation
                2'b11 : assert (r_seq_item.randomize() with {r_seq_item.din[9:8] dist {  2'b00 := 60, 2'b10 := 40};});
                default: assert (r_seq_item.randomize());
            endcase

            finish_item(r_seq_item);
        end
        // We directed 1 case of sequence din[9:8] 0 => 1 => 2 => 3 to make sure it will happen atleast 1 time
        r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
        start_item(r_seq_item);
        r_seq_item.din[9:8] = 2'b00;
        finish_item(r_seq_item);
        
        r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
        start_item(r_seq_item);
        r_seq_item.din[9:8] = 2'b01;
        finish_item(r_seq_item);
        
        
        r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
        start_item(r_seq_item);
        r_seq_item.din[9:8] = 2'b10;
        finish_item(r_seq_item);
        
        r_seq_item = RAM_seq_item::type_id::create("r_seq_item");
        start_item(r_seq_item);
        r_seq_item.din[9:8] = 2'b11;
        finish_item(r_seq_item);

    endtask
  endclass : RAM_read_write_seq

endpackage : RAM_seqs
