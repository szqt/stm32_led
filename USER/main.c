/****************************************Copyright (c)****************************************************
**                                      
**                                 http://www.powermcu.com
**
**--------------File Info---------------------------------------------------------------------------------
** File name:               main.c
** Descriptions:            The FLASH application function
**
**--------------------------------------------------------------------------------------------------------
** Created by:              AVRman
** Created date:            2010-10-30
** Version:                 v1.0
** Descriptions:            The original version
**
**--------------------------------------------------------------------------------------------------------
** Modified by:             
** Modified date:           
** Version:                 
** Descriptions:            
**
*********************************************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x.h"
#include <stdio.h>


/*
#ifdef __GNUC__
   With GCC/RAISONANCE, small printf (option LD Linker->Libraries->Small printf
     set to 'Yes') calls __io_putchar()
  #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
  #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif  __GNUC__
*/

#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)

/* Private define ------------------------------------------------------------*/
#define  FLASH_ADR   0x0801F000  		/* �洢���Flashҳ�׵�ַ 128K */
#define	 FLASH_DATA	 0x5a5a5a5a		    /* д������ */

/* Private functions ---------------------------------------------------------*/
void GPIO_Configuration(void);
void USART_Configuration(void);


/*******************************************************************************
* Function Name  : Delay
* Description    : Delay Time
* Input          : - nCount: Delay Time
* Output         : None
* Return         : None
* Attention		 : None
*******************************************************************************/
void  Delay (uint32_t nCount)
{
  for(; nCount != 0; nCount--);
}

/*******************************************************************************
* Function Name  : main
* Description    : Main program
* Input          : None
* Output         : None
* Return         : None
* Attention		 : None
*******************************************************************************/
int main(void)
{
    uint32_t FlashData;

	GPIO_Configuration();
	USART_Configuration();
	printf("\r\n");
	printf("***************************************************************\r\n");
    printf("*                                                             *\r\n");
	printf("*  Thank you for using HY-MiniSTM32V Development Board ! ^_^  *\r\n");
	printf("*                                                             *\r\n");
	printf("***************************************************************\r\n");

	/* �жϴ�FLASH�Ƿ�Ϊ�հ� */
	FlashData=*(vu32*)(FLASH_ADR);	 /* ��ȡ��ַ�е�16λ��� */
	if(FlashData==0xffffffff)
	{
		FLASH_Unlock();		/* ÿ�β���Flash�����ʱ���Ƚ��� */
		FLASH_ProgramWord(FLASH_ADR,FLASH_DATA);   /* д16λ���� */
		FLASH_Lock();							   /* ���� */
		printf("\r\nҪд��ĵ�ַΪ��,д����֤��� \r\n");
	}
	else if(FlashData==FLASH_DATA)
	{
		printf("\r\n��ַ�������֤��ݷ�� \r\n");
	}
	else
	{
		printf("\r\n��ַ�ϵ��������֤����ݲ����,�п�����д��ʧ�ܻ�����Ҫд��ĵ�ַ�ǿ�\r\n");
	    FLASH_Unlock();
		FLASH_ErasePage(FLASH_ADR);		  /* ����ҳ */
		FLASH_Lock();
		printf("\r\n�Ѿ�ˢ��Ҫд��ĵ�ַ\r\n");
	}

    /* Infinite loop */
    while (1)
	{
		/* LED1-ON LED2-OFF */
		GPIO_SetBits(GPIOB , GPIO_Pin_0);
		GPIO_ResetBits(GPIOB , GPIO_Pin_1);
		Delay(0xfffff);
		Delay(0xfffff);
		Delay(0x5ffff);	

		/* LED1-OFF LED2-ON */
		GPIO_ResetBits(GPIOB , GPIO_Pin_0);
		GPIO_SetBits(GPIOB , GPIO_Pin_1);
		Delay(0xfffff);
		Delay(0xfffff);
		Delay(0x5ffff);				
    }
}

/*******************************************************************************
* Function Name  : GPIO_Configuration
* Description    : Configure GPIO Pin
* Input          : None
* Output         : None
* Return         : None
* Attention		 : None
*******************************************************************************/
void GPIO_Configuration(void)
{
  GPIO_InitTypeDef GPIO_InitStructure;
  
  RCC_APB2PeriphClockCmd( RCC_APB2Periph_GPIOB , ENABLE); 						 
/**
 *	LED1 -> PB0   LED2 -> PB1
 */					 
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP; 
  GPIO_Init(GPIOB, &GPIO_InitStructure);
}

/*******************************************************************************
* Function Name  : USART_Configuration
* Description    : Configure USART1 
* Input          : None
* Output         : None
* Return         : None
* Attention		 : None
*******************************************************************************/
void USART_Configuration(void)
{ 
  GPIO_InitTypeDef GPIO_InitStructure;
  USART_InitTypeDef USART_InitStructure; 

  RCC_APB2PeriphClockCmd( RCC_APB2Periph_GPIOA | RCC_APB2Periph_USART1,ENABLE);
  /*
  *  USART1_TX -> PA9 , USART1_RX ->	PA10
  */				
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;	         
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP; 
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz; 
  GPIO_Init(GPIOA, &GPIO_InitStructure);		   

  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;	        
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;  
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz; 
  GPIO_Init(GPIOA, &GPIO_InitStructure);

  USART_InitStructure.USART_BaudRate = 115200;
  USART_InitStructure.USART_WordLength = USART_WordLength_8b;
  USART_InitStructure.USART_StopBits = USART_StopBits_1;
  USART_InitStructure.USART_Parity = USART_Parity_No;
  USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
  USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;

  USART_Init(USART1, &USART_InitStructure); 
  USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);
  USART_ITConfig(USART1, USART_IT_TXE, ENABLE);
  USART_Cmd(USART1, ENABLE);
}

/**
  * @brief  Retargets the C library printf function to the USART.
  * @param  None
  * @retval None
  */
PUTCHAR_PROTOTYPE
{
  /* Place your implementation of fputc here */
  /* e.g. write a character to the USART */
  USART_SendData(USART1, (uint8_t) ch);

  /* Loop until the end of transmission */
  while (USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET)
  {}

  return ch;
}

#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif

/*********************************************************************************************************
      END FILE
*********************************************************************************************************/

