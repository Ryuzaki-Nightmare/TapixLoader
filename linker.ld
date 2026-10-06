ENTRY(start) /*Initial funcion in boot/bootloader.s*/
OUTPUT_FORMAT(binary)
SECTIONS
{
    .text :
    {
           *(.text) 
    }
    .data :
    {
        *(.data)    
    }
    .bss:
    {
        *(.COMMON)
        *(.bss)
    }
}
