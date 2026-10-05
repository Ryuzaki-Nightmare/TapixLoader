ENTRY(start) /*Initial funcion in boot/bootloader.s*/
OUTPUT_FORMAT(elf64-x86-64)
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
