# Project name
PROJECT=GLCD

# Directory definitions
GLCD_SRC_DIR=./GLCD
SYSTICK_SRC_DIR=./SysTick
ST_LIB_DIR=./std_periph_drivers
ARM_CMSIS_CORE_DIR=./CM3/CoreSupport
ARM_CMSIS_DEVICE_DIR=./CM3/DeviceSupport/ST/STM32F10x
ARM_CMSIS_STARTUP_ASM_DIR=$(ARM_CMSIS_DEVICE_DIR)/startup/TrueSTUDIO
USER_DIR=./USER

# Directory for output files
OUTDIR=Debug

# Toolchain
CROSS_COMPILE=arm-none-eabi
CC=$(CROSS_COMPILE)-gcc
AS=$(CROSS_COMPILE)-gcc
LD=$(CROSS_COMPILE)-gcc
CP=${CROSS_COMPILE}-objcopy


OBJDUMP=$(CROSS_COMPILE)-size
NM=$(CROSS_COMPILE)-nm

LDSCRIPT=stm32_flash.ld

# should use --gc-sections but the debugger does not seem to be able to cope with the option
#LDFLAGS=-nostartfiles -o$(PROJECT).axf -Map=$(PROJECT).map -T$(LDSCRIPT) --no-gc-sections -M

LDFLAGS=-Xlinker -M -Xlinker -Map=$(OUTDIR)/$(PROJECT).map -T $(LDSCRIPT)

# Debugging format
DEBUG= gdb

# Optimization level, can be [0, 1, 2, 3, s].
# 0 = turn off optimization. s = optimize for size.
# (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
OPT = 0

# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
CSTANDARD = gnu99

STM32F=	-DUSE_STM3210E_EVAL \
		-DSTM32F10X_HD \
		-DUSE_STDPERIPH_DRIVER \
		-DGCC_ARMCM3

CFLAGS=	-g -mthumb -mcpu=cortex-m3 -Wall
ASFLAGS=-g -mthumb -mcpu=cortex-m3 -Wall

INC=	-I$(USER_DIR) \
		-I$(ARM_CMSIS_CORE_DIR)\
		-I$(ARM_CMSIS_DEVICE_DIR) \
		-I$(ST_LIB_DIR)/inc \
		-I$(SYSTICK_SRC_DIR) \
		-I$(GLCD_SRC_DIR)\

# ST library source
ST_LIB_SRC= \
		$(ARM_CMSIS_CORE_DIR)/core_cm3.c \
		$(ST_LIB_DIR)/src/misc.c \
		$(ST_LIB_DIR)/src/stm32f10x_rcc.c \
		$(ST_LIB_DIR)/src/stm32f10x_gpio.c \
		$(ST_LIB_DIR)/src/stm32f10x_spi.c \
		$(ST_LIB_DIR)/src/stm32f10x_tim.c \
		$(ST_LIB_DIR)/src/stm32f10x_usart.c \
		$(ST_LIB_DIR)/src/stm32f10x_fsmc.c \
		$(ST_LIB_DIR)/src/stm32f10x_flash.c \
		$(ST_LIB_DIR)/src/stm32f10x_adc.c

# GLCD library source
GLCD_SRC= $(GLCD_SRC_DIR)/AsciiLib.c \
		$(GLCD_SRC_DIR)/HzLib.c \
		$(GLCD_SRC_DIR)/GLCD.c


# SysTick library source
SYSTICK_SRC=$(SYSTICK_SRC_DIR)/stm32f10x_systick.c \
		$(SYSTICK_SRC_DIR)/systick.c

# STM32 vector table source
VECTOR_SRC=$(wildcard $(ARM_CMSIS_STARTUP_ASM_DIR)/startup_stm32f10x_ld.s)

CM3_SRC=$(ARM_CMSIS_DEVICE_DIR)/system_stm32f10x.c

SRC=USER/main.c USER/newlib_stubs.c $(CM3_SRC) $(VECTOR_SRC) $(SYSTICK_SRC) $(ST_LIB_SRC) $(GLCD_SRC)

OBJS = $(addprefix $(OUTDIR)/, $(addsuffix .o, $(ALLSRCBASE)))

LIBS= # no additional external libraries yet

#  C source files
CFILES = $(filter %.c, $(SRC))

#  Assembly source files
ASMFILES = $(filter %.s, $(SRC))

# Object filse
COBJ = $(CFILES:.c=.o)
SOBJ = $(ASMFILES:.s=.o)
OBJ  = $(COBJ) $(SOBJ)


all: $(SRC) $(PROJECT).elf $(PROJECT).bin

$(PROJECT).bin: $(PROJECT).elf
	$(CP) -O binary $(OUTDIR)/$(PROJECT).elf $(OUTDIR)/$@

$(PROJECT).elf: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $(OUTDIR)/$@

$(COBJ): %.o: %.c
	$(CC) -c $(STM32F) $(INC) $(CFLAGS) $< -o $@

$(SOBJ): %.o: %.s
	$(AS) -c $(ASFLAGS) $< -o $@


clean:
	rm -rf $(OUTDIR) $(OBJ)


log: $(PROJECT).elf
	$(NM) -n $(PROJECT).elf > $(OUTDIR)/$(PROJECT)_SymbolTable.txt
	$(OBJDUMP) --format=SysV $(PROJECT).elf > $(OUTDIR)/$(PROJECT)_MemoryListingSummary.txt
	$(OBJDUMP) $(OBJS) > $(OUTDIR)/$(PROJECT)_MemoryListingDetails.txt


# Display compiler version information.
gccversion :
	@$(CC) --version

$(shell mkdir $(OUTDIR) 2>/dev/null)

install0: all
	stm32loader.py -ew -p /dev/ttyUSB0 $(OUTDIR)/$(PROJECT).bin

install1: all 
	stm32loader.py -ew -p /dev/ttyUSB1 $(OUTDIR)/$(PROJECT).bin

jtag: all
	echo "reset halt" | nc localhost 4444
	sleep 1
	echo "stm32f1x mass_erase 0" | nc localhost 4444
	sleep 1
	echo "flash write_bank 0 Debug/stm32_freertos_example.bin 0" | nc localhost 4444
	sleep 2
	echo "reset halt" | nc localhost 4444

oldjtag: all
	echo "reset halt" | nc localhost 4444
	echo "stm32f1x mass_erase 0" | nc localhost 4444
	sleep 1
	echo "flash write_bank 0 GLCD.bin 0" | nc localhost 4444
	sleep 2
	echo "reset halt" | nc localhost 4444

run: jtag
	echo "reset run" | nc localhost 4444
