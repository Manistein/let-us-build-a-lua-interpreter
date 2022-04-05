// Direct2D.cpp : Defines the entry point for the application.
//

#include <windows.h>
#include "logic.h"

#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;                                // current instance
WCHAR* szTitle = L"";                  // The title bar text
WCHAR* szWindowClass = L"Tetris";            // the main window class name
HWND g_hWnd = NULL;
int g_iScreenWidth = 800;
int g_iScreenHeight = 650;

const int iFrameGapByMillisecond = 33;

// Forward declarations of functions included in this code module:
ATOM                MyRegisterClass(HINSTANCE hInstance);
BOOL                InitInstance(HINSTANCE, int);
LRESULT CALLBACK    WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK    About(HWND, UINT, WPARAM, LPARAM);

BOOL g_Quit = FALSE;

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPWSTR    lpCmdLine,
	_In_ int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	// TODO: Place code here.
	MyRegisterClass(hInstance);

	// Perform application initialization:
	if (!InitInstance(hInstance, nCmdShow))
	{
		DWORD err = GetLastError();
		return FALSE;
	}

	int ret = logic_init((void*)g_hWnd, g_iScreenWidth, g_iScreenHeight);
	if (!ret)
	{
		return FALSE;
	}

	MSG msg;
	// Main message loop:
	int last_millisecond = (int)GetTickCount();
	while (!g_Quit)
	{
		if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}

		int current_millisecond = (int)GetTickCount();
		if (current_millisecond - last_millisecond > iFrameGapByMillisecond)
		{
			if (!logic_frame(current_millisecond - last_millisecond)) 
			{
				g_Quit = TRUE;
				break;
			}
			last_millisecond = current_millisecond;
		}
	}
	
	logic_destroy();
	return (int)msg.wParam;
}

//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEXW wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = (HICON)LoadIcon(hInstance, MAKEINTRESOURCE(IDI_WINLOGO));
	wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = (HICON)LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_WINLOGO));

	return RegisterClassExW(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
	hInst = hInstance; // Store instance handle in our global variable

	HWND hwnd = CreateWindowW(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW^WS_THICKFRAME^WS_MAXIMIZEBOX,
		0, 0, g_iScreenWidth, g_iScreenHeight, nullptr, nullptr, hInstance, nullptr);

	if (!hwnd)
	{
		return FALSE;
	}

	ShowWindow(hwnd, nCmdShow);
	UpdateWindow(hwnd);

	g_hWnd = hwnd;
	return TRUE;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE: Processes messages for the main window.
//
//  WM_COMMAND  - process the application menu
//  WM_PAINT    - Paint the main window
//  WM_DESTROY  - post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
	case WM_DESTROY:
	{
		g_Quit = true;
		PostQuitMessage(0);
	}
	break;
	case WM_KEYDOWN:
	{
		if (GetKeyState('W') & 0x8000)
		{
			logic_key_w_press();
		}
		else if (GetKeyState('S') & 0x8000)
		{
			logic_key_s_press();
		}
		else if (GetKeyState('A') & 0x8000)
		{
			logic_key_a_press();
		}
		else if (GetKeyState('D') & 0x8000)
		{
			logic_key_d_press();
		}
		else if (GetKeyState(VK_SPACE) & 0x8000)
		{
			logic_key_space_press();
		}
		else if (GetKeyState(VK_RETURN) & 0x8000)
		{
			logic_key_enter_press();
		}
		else if (GetKeyState(VK_ESCAPE) & 0x8000)
		{
			logic_key_esc_press();
		}
	}
	break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}