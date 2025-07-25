#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>
#include<SDL2/SDL.h>
#include<SDL2/SDL2_gfxPrimitives.h>

#define WIDTH 250
#define HEIGTH 250
#define PI 3.14159265358979323846
#define OFFSET 10

int width = WIDTH;
int heigth = HEIGTH;

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;

int radius;
int c_x;
int c_y;

void SetValues(int w,int h);
void DrawClockHands(int h,int m,int s);

void Init();
void Loop();
void Close();


int main()
{
	Init();
	Loop();
	Close();

	return 0;
}

void Init()
{
	if(SDL_Init(SDL_INIT_VIDEO) != 0)
	{
		fprintf(stderr,"SDL_Init error: %s\n",SDL_GetError());
		exit(EXIT_FAILURE);
	}

	window = SDL_CreateWindow("Clock",
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
			width, heigth,
			SDL_WINDOW_RESIZABLE
			);

	if(window == NULL)
	{
		fprintf(stderr,"SDL_CreateWindow error: %s\n",SDL_GetError());
		SDL_Quit();
		exit(EXIT_FAILURE);
	}

	Uint32 renderer_flags = SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC;

	renderer = SDL_CreateRenderer(window, -1, renderer_flags);

	if(renderer == NULL)
	{
		fprintf(stderr,"SDL_CreateRenderer error: %s\n",SDL_GetError());
		SDL_DestroyWindow(window);
		SDL_Quit();
		exit(EXIT_FAILURE);
	}
}

void Loop()
{
	SDL_bool done = SDL_FALSE;
	SDL_Event e;
	time_t raw;
	struct tm * tm_p = NULL;

    SetValues(WIDTH,HEIGTH);
    Uint32 windowID = SDL_GetWindowID(window);

	while(!done)
	{
		while (SDL_PollEvent(&e))
		{
			switch(e.type)
			{
                case SDL_WINDOWEVENT:
                    if(e.window.windowID==windowID &&
                            e.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
                     SetValues(e.window.data1,e.window.data2);
                    break;

                case SDL_KEYDOWN:
                    switch(e.key.keysym.sym)
                    {
                        case SDLK_q:
                            done = SDL_TRUE;
                            break;
                    }
                    break;

				case SDL_QUIT:
					done = SDL_TRUE;
					break;
			}
		}

		SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
		SDL_RenderClear(renderer);

		for(int u=0; u<=360; u+=6)
		{
			double rad = u*PI/180;
			int x = c_x+radius*cos(rad);
			int y = c_y+radius*sin(rad);
			if(u%30)
				pixelRGBA(renderer,x,y,0xff,0,0,0xff);
			else
				pixelRGBA(renderer,x,y,0,0,0xff,0xff);

		}

		time(&raw);
		tm_p = localtime(&raw);
		DrawClockHands(tm_p->tm_hour,tm_p->tm_min,tm_p->tm_sec);

        SDL_RenderPresent(renderer);
	}
}

void SetValues(int w,int h)
{
    width=w;
    heigth=h;
    radius = (width<heigth? width:heigth)/2-OFFSET;
    c_x = width/2;
    c_y = heigth/2;
}

void DrawClockHands(int h,int m,int s)
{
	double radians_sec,radians_min,radians_h;
	int x,y;
	radians_sec = s*PI/30;
	radians_min = (m+s/60.0)*PI/30;
	radians_h = (h+m/60.0)*PI/6;
	x = c_x+(radius/2)*cos(radians_h+3*PI/2);
	y = c_y+(radius/2)*sin(radians_h+3*PI/2);
	thickLineRGBA(renderer,c_x,c_y,x,y,8,0,0,0xff,0xff);
	x = c_x+(3*radius/4)*cos(radians_min+3*PI/2);
	y = c_y+(3*radius/4)*sin(radians_min+3*PI/2);
	thickLineRGBA(renderer,c_x,c_y,x,y,4,0,0xff,0,0xff);
	x = c_x+(7*radius/8)*cos(radians_sec+3*PI/2);
	y = c_y+(7*radius/8)*sin(radians_sec+3*PI/2);
	thickLineRGBA(renderer,c_x,c_y,x,y,2,0xff,0,0,0xff);
}

void Close()
{
	if(renderer) SDL_DestroyRenderer(renderer);
	if(window) SDL_DestroyWindow(window);
	SDL_Quit();
}
