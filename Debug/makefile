################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include std_periph_drivers/src/subdir.mk
-include SysTick/subdir.mk
-include GLCD/subdir.mk
-include CM3/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: stm32_glcd

# Tool invocations
stm32_glcd: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: Cross GCC Linker'
	arm-none-eabi-gcc -nostartfiles -T"" -mthumb -mcpu=cortex-m3 -ffunction-sections -fdata-sections -ggdb -Xlinker -M -Xlinker -Map=RTOSBrew.map -Xlinker --no-gc-sections -o "stm32_glcd" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES) stm32_glcd
	-@echo ' '

post-build:
	-@echo 'Create binary output'
	-arm-none-eabi-objcopy stm32_glcd -O binary stm32_glcd.bin
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY: post-build

-include ../makefile.targets
