################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../SysTick/stm32f10x_systick.c \
../SysTick/systick.c 

OBJS += \
./SysTick/stm32f10x_systick.o \
./SysTick/systick.o 

C_DEPS += \
./SysTick/stm32f10x_systick.d \
./SysTick/systick.d 


# Each subdirectory must supply rules for building sources it contributes
SysTick/%.o: ../SysTick/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Compiler'
	arm-none-eabi-gcc -DSTM32F10X_HD -DUSE_STDPERIPH_DRIVER -DVECT_TAB_FLASH -DGCC_ARMCM3 -Dinline= -DPACK_STRUCT_END=__attribute\(\(packed\)\) -DALIGN_STRUCT_END=__attribute\(\(aligned\(4\)\)\) -I"/home/ubuntu/workspace/stm32_glcd/CM3" -I"/home/ubuntu/workspace/stm32_glcd" -I"/home/ubuntu/workspace/stm32_glcd/std_periph_drivers/inc" -I"/home/ubuntu/workspace/stm32_glcd/GLCD" -O1 -g -c -fmessage-length=0 -std=gnu99 -mthumb -mcpu=cortex-m3 -ffunction-sections  -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


