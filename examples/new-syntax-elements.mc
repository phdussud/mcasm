
cond uaddr:3;



/*--------------------------------------------------------------------------------
-- ROM ( output ) Field definitions
--------------------------------------------------------------------------------
*/

field NS              = XXX_______;  //-- Next State
signal mem_addr_ini   = NS.0b001;  //signal expressed as a field value. The value is checked for overflow of the field
signal max_number_ini = NS.0b010;



//default field address to allow specifying branching with labels without a field prefix.
field address =   ___XXX____;  //-- Branch destination



//--  TS - Test operations
field TS       = ______XX__;  //-- Test Operation Select (never, always, t1, t2)
signal always  = TS.0b01;       
signal lt_max  = TS.0b10;       
signal eq_last = TS.0b11;       

//--  MS - Memory Operation Select Definitions
field MS       = ________X_;  //-- Memory Operation Select(none, write)
signal Wr      = MS.0b1;      //-- Write to max

//--  IS - Memory Address operations
field IS       = _________X;  //-- Addr Inc
signal /Inc     = IS.0b1;      //-- Increment address

//signal composed of other signals. It produce better listings than defining a C macro
//that gets expanded before the listing is produced.
signal jmp = NS.0b111, always
signal jmp_if_mem_data_lt_max = NS.0b011, lt_max
signal max_number_assign = NS.0b100, Wr
signal jmp_if_mem_addr_eq_last = NS.0b101, eq_last
signal mem_addr_inc = NS.0b110, /Inc



/*--------------------------------------------------------------------------------
-- ROM Microprogram Start
--------------------------------------------------------------------------------
*/

start uaddr=0;
_start:
   mem_addr_ini;
   max_number_ini;
_loop1:
      jmp_if_mem_data_lt_max, address._next1; 
      max_number_assign;
_next1:
      jmp_if_mem_addr_eq_last, _Last; //labels can be specified without a field prefix if the field "address" is defined
      mem_addr_inc;
      jmp, _loop1

_Last: 
   jmp, _Last;
