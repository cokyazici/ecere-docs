/**************************************************************************/
/*  THIS PROGRAM IS NON-COPYRIGHTED PUBLIC DOMAIN AND DISTRIBUTED IN THE  */
/*  HOPE THAT IT WILL BE USEFUL BUT THERE IS NO WARRANTY FOR THE PROGRAM, */
/*  THE PROGRAM IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER  */
/*  EXPRESSED  OR  IMPLIED, INCLUDING, BUT  NOT  LIMITED TO, THE IMPLIED  */
/*  WARRANTIES  OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. */
/*  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM  IS  */
/*  WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF  */
/*  ALL NECESSARY SERVICING, REPAIR OR CORRECTION.                        */
/**************************************************************************/

/* makemiss.c make missing HTML files as empty files by NECDET COKYAZICI  */

#include <math.h>
#include <time.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <errno.h>

FILE *naji_input;
FILE *naji_output;

void najin(char *namein);
void najout(char *nameout);
void najinclose(void);
void najoutclose(void);
void najifgets(char *buf, int size, FILE *input);
void safegets(char *buf, int size);

void najin(char *namein)
{
int a;

    naji_input = fopen(namein, "rb");

    if (naji_input == NULL)
    {
    fprintf(stderr, "\n\nError, cannot open input file: %s", namein);
    perror(" "); fprintf(stderr, "\n\n");
    exit(2);
    }

	
	a = fgetc(naji_input);
	
	if (a == EOF)
    {
    fprintf(stderr, "\n\nError, empty file.\n\n");
    exit(1);
    }
	else
	{
		najinclose();
		
		naji_input = fopen(namein, "rb");

		if (naji_input == NULL)
		{
		fprintf(stderr, "\n\nError, cannot open input file: %s", namein);
		perror(" "); fprintf(stderr, "\n\n");
		exit(2);
		}
	
	}


}


void najout(char *nameout)
{
int choice;
char buffer[1050];

naji_output = fopen(nameout, "rb");


    if (naji_output != NULL)
    {
    fprintf(stderr, "\n\nError, output file already exists: %s\n\n", nameout);

        while (1)
        {

            fprintf(stderr, "[Q]uit - [R]ename - [O]verwrite ?\n\n");
            choice = fgetc(stdin);

            if (choice == 'q' || choice == 'Q')
            {
            fclose(naji_output);
            exit(3);
            }


            else if (choice == 'r' || choice == 'R')
            {

            fprintf(stderr, "\nType new name for output file: ");

            fgetc(stdin);
            safegets(buffer, 1024);

                fclose(naji_output);

                if (rename(nameout, buffer) != 0)
                {
                perror("\n\nError renaming output file");
                fclose(naji_output);
                exit(3);
                }

                else break;

            }

          else if (choice == 'o' || choice == 'O')
          {
          fclose(naji_output);
          break;
          }

          else continue;

        }


    }

    naji_output = fopen(nameout, "wb");
    if (naji_output == NULL)
    {
    fprintf(stderr, "\n\nError, cannot open output file: %s", nameout);
    perror(" "); fprintf(stderr, "\n\n");
    exit(4);
    }

}


void najinclose(void)   { fclose(naji_input);   }


void najoutclose(void)  { fclose(naji_output);  }


void najifgets(char *buf, int size, FILE *input)
{
int a;
int i=0;

    while(1)
    {
    
        a = fgetc(naji_input);

        if (a == EOF)
		{
		buf[i] = '\0';
		return;
		}
		
		if (i == size)
        {
		buf[i+1] = '\0';
		return;
		}

        if (a == '\n')
        {
		buf[i]   = '\n';
		buf[i+1] = '\0';
        return;
        }
        else
		{
        buf[i] = a;
		buf[i+1] = '\0';
        }
		
		i++;
    
    }

}


void safegets(char *buf, int size)
{
int a;
int i=0;

    while(1)
    {
    
        a = fgetc(stdin);

        if (i == size)
        {
        buf[size] = '\0';
        if ( (a == '\n') || (a == '\r') ) return;
        }

        if (i < size)
        {
    
            if ( (a == '\n') || (a == '\r') )
            {
            buf[i]='\0';
    
            return;
            }
    
            if ( (a > 31) && (a < 127) )
            {
            buf[i]=a;
            i++;
            }

        }    
    
    }

}


int main()
{
char temp[4096];
char buffer[4096];

char *p = NULL;
int i = 0;

najin("index.html");


	while (1)
	{
	
	
		if (feof(naji_input))
		break;

		najifgets(temp, 4095, naji_input);
	
		p = strstr(temp, "<a href=\"");

			
		if (p != NULL)
		{

		i  = 0;
		p += 9;
		
			while (1)
			{
				
				if ( (*p == '\0') || (*p == '\"') )
				{
				buffer[i] = '\0';
				printf("Making empty file: \"%s\"\n", buffer);
				najout(buffer);
				najoutclose();
				break;
				}

				buffer[i] = *p;
				i++;
				p++;
	
			}
		
		
		}
	
	}	


najinclose();
}
