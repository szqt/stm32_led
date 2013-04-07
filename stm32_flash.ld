/**
 * <b>File:</b> stm32_flash.ld
 *
 * <b>Project:</b> FreeRTOS.org STM32 demo using Eclipse
 *
 * <b>Description:</b> Linker script to load the application in the STM32 internal flash.
 * It works with the crt0_STM32x.c startup file.
 *
 * <b>Cereated:</b> 24/06/2008
 *
 * <dl>
 * <dt><b>Autor</b>:</dt>
 * <dd>Stefano Oliveri</dd>
 * <dt><b>E-mail:</b></dt>
 * <dd>software@stf12.net</dd>
 * </dl>
 */

/* global needed for startup_stm3210x_*.s */
_estack = 0x20002000;

/* 256 bytes miniumum stack size */
_minimum_stack_size = 0x100;

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 512K
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}

SECTIONS
{
	.text :
	{
		_stext = .;

		KEEP(*(.isr_vector))

		*(.text .text.* .gnu.linkonce.t.*)
		*(.rodata .rodata.* .gnu.linkonce.r.*)

		*(.eh_frame_hdr)
		*(.eh_frame)
		*(.ARM.extab* .gnu.linkonce.armextab.*)
		*(.gcc_except_table)
		*(.eh_frame_hdr)
		*(.eh_frame)

		. = ALIGN(4);
		KEEP(*(.init))

		. = ALIGN(4);
		__preinit_array_start = .;
		KEEP (*(.preinit_array))
		__preinit_array_end = .;

		. = ALIGN(4);
		__init_array_start = .;
		KEEP (*(SORT(.init_array.*)))
		KEEP (*(.init_array))
		__init_array_end = .;

		. = ALIGN(0x4);
		KEEP (*crtbegin.o(.ctors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
		KEEP (*(SORT(.ctors.*)))
		KEEP (*crtend.o(.ctors))

		. = ALIGN(4);
		KEEP(*(.fini))
		. = ALIGN(4);
		__fini_array_start = .;
		KEEP (*(.fini_array))
		KEEP (*(SORT(.fini_array.*)))
		__fini_array_end = .;

		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*crtend.o(.dtors))

		. = ALIGN(8);
		_etext = .;

	} >FLASH

	/* .ARM.exidx is sorted, so has to go in its own output section. */
	__exidx_start = .;

	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} >FLASH
	__exidx_end = .;

	/* global needed for startup_stm3210x*.s */
	_sidata = .; 

	_flash_data = .;
	.data : AT (_flash_data)
	{
		/* global needed for startup_stm3210x*.s */
		_sdata = .;
		_data = .;
		*(vtable)
		*(.data*)
		_edata = .;
	} > SRAM

	.bss :
	{
		/* global needed for startup_stm3210x*.s */
		_sbss = .;
		_bss = .;
		*(.bss*)
		*(COMMON)
		_ebss = .;
		_end = .;
		__end = .;
	} > SRAM
}

/* end of allocated ram _end */

PROVIDE( _heap = _end );

/* end of the heap -> align 8 byte */

PROVIDE ( _eheap = ALIGN(ORIGIN(SRAM) + LENGTH(SRAM) - 8 ,8) );
