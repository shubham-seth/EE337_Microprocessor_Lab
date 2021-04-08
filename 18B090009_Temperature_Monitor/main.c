#include <at89c5131.h>
#include "lcd.h"
#include "mcp3008.h"

char adc_ip_data_ascii[6]={0,0,0,'\0'};
code unsigned char display_msg2[]="Ave. Temp:  ";
char display_msg1[]={0,0,'.',0,',',' ','\0'};
unsigned int temp[]={0,0,0,0,0,0,0,0,0,0};

void right_rotate(unsigned int A[], int x)
{
	int i;
	int t;
	for(i=0; i<9; i++)
	{
		t = A[i];
		A[i] = A[i+1];
		A[i+1] = t;
	}
	A[9] = x;
}

void temp_display(int x)
{
	int_to_string(x,adc_ip_data_ascii);
	display_msg1[0] = adc_ip_data_ascii[0];
	display_msg1[1] = adc_ip_data_ascii[1];
	display_msg1[3] = adc_ip_data_ascii[2];
	lcd_write_string(display_msg1);
}

unsigned int average(unsigned int A[])
{
	unsigned int avg=0;
	int i;
	for(i=0; i<10; i++)
		avg += A[i];
	avg /= 10;
	return avg;
}

void alarm(void)
{
	int i;
	for(i=0; i<250; i++)
	{
		P0 = 0x01;
		msdelay(1);
		P0 = 0x00;
		msdelay(1);
	}
}

int blink_led(int flag)
{
	
	P3 = 0x03;
	alarm();
	P3 = 0x00;
	alarm();
	return (flag+1)%4;
}

void main(void)
{
	int flag=0;
	unsigned int adc_data=0;
	unsigned int x;
	float temperature;
	P3 = 0x00; // Initially leds are on 
	
	spi_init();																					
	adc_init();
  lcd_init();
	
	while(1)
	{
		x = adc(7);
		temperature = (x*0.32258);
		x = (unsigned int) (temperature*10.0);

		right_rotate(temp, x);
		
		lcd_cmd(0x80);
		temp_display(temp[9]);
		temp_display(temp[8]);
		temp_display(temp[7]);
		
		if(flag == 0)
		{
			lcd_cmd(0xC0);
			lcd_write_string(display_msg2);
			x = average(temp);
			temp_display(x);
		
			if(temp[9]<(x-20) || temp[9]>(x+20))
				flag = blink_led(flag);
			else
				msdelay(1000);
		}
		else
			flag = blink_led(flag);
	}
}