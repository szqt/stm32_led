################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../GLCD/AsciiLib.c \
../GLCD/GLCD.c \
../GLCD/HzLib.c 

OBJS += \
./GLCD/AsciiLib.o \
./GLCD/GLCD.o \
./GLCD/HzLib.o 

C_DEPS += \
./GLCD/AsciiLib.d \
./GLCD/GLCD.d \
./GLCD/HzLib.d 


# Each subdirectory must supply rules for building sources it contributes
GLCD/%.o: ../GLCD/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Compiler'
	arm-none-eabi-gcc -DSTM32F10X_HD -DUSE_STDPERIPH_DRIVER -DVECT_TAB_FLASH -DGCC_ARMCM3 -Dinline= -DPACK_STRUCT_END=__attribute\(\(packed\)\) -DALIGN_STRUCT_END=__attribute\(\(aligned\(4\)\)\) -I"/home/ubuntu/workspace/stm32_glcd/CM3" -I"/home/ubuntu/workspace/stm32_glcd" -I"/home/ubuntu/workspace/stm32_glcd/std_periph_drivers/inc" -I"/home/ubuntu/workspace/stm32_glcd/GLCD" -O1 -g -c -fmessage-length=0 -std=gnu99 -mthumb -mcpu=cortex-m3 -ffunction-sections  -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


