#include "render.h"

#define MAX_TEXT_STACK_BUFFER 256
struct TextBUffer {
	size_t size;
	WCHAR* buffer;
};

static TextBUffer g_wchar_buffer = {0, NULL};

static HWND g_hwnd = NULL;
static ID2D1Factory* g_d2d_factory = NULL;
static ID2D1HwndRenderTarget* g_render_target = NULL;

// box
static ID2D1SolidColorBrush* g_box_outlie_brush = NULL;
static ID2D1SolidColorBrush* g_box_solid_brushs[MAX_BOX_BLUSH];

// text
static IDWriteFactory* g_write_factory = NULL;
static IDWriteTextFormat* g_write_format = NULL;
static ID2D1SolidColorBrush* g_text_brush = NULL;

int render_init(HWND hwnd) {
	HRESULT hr = D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, &g_d2d_factory);
	if (!SUCCEEDED(hr)) {
		return 0;
	}

	// Obtain the size of the drawing area.
	RECT rc;
	GetClientRect(hwnd, &rc);

	// Create a Direct2D render target          
	hr = g_d2d_factory->CreateHwndRenderTarget(
		D2D1::RenderTargetProperties(),
		D2D1::HwndRenderTargetProperties(
			hwnd,
			D2D1::SizeU(
				rc.right - rc.left,
				rc.bottom - rc.top)
		),
		&g_render_target
	);

	if (!SUCCEEDED(hr)) {
		return 0;
	}

	hr = g_render_target->CreateSolidColorBrush(
		D2D1::ColorF(D2D1::ColorF::Orange),
		&g_box_outlie_brush
	);

	if (!SUCCEEDED(hr)) {
		return 0;
	}

	D2D1_COLOR_F colors[] = {
		D2D1::ColorF(D2D1::ColorF::DarkRed),
		D2D1::ColorF(D2D1::ColorF::LightYellow),
		D2D1::ColorF(D2D1::ColorF::Blue),
		D2D1::ColorF(D2D1::ColorF::Green)
	};
	for (int i = 0; i < MAX_BOX_BLUSH; i++) {
		hr = g_render_target->CreateSolidColorBrush(colors[i], &g_box_solid_brushs[i]);
		if (!SUCCEEDED(hr)) {
			return 0;
		}
	}

	// Create a DirectWrite factory.
	hr = DWriteCreateFactory(
		DWRITE_FACTORY_TYPE_SHARED,
		__uuidof(g_write_factory),
		reinterpret_cast<IUnknown **>(&g_write_factory)
	);

	if (!SUCCEEDED(hr)) {
		return 0;
	}

	const WCHAR msc_fontName[] = L"Verdana";
	const FLOAT msc_fontSize = 18;
	// Create a DirectWrite text format object.
	hr = g_write_factory->CreateTextFormat(
		msc_fontName,
		NULL,
		DWRITE_FONT_WEIGHT_NORMAL,
		DWRITE_FONT_STYLE_NORMAL,
		DWRITE_FONT_STRETCH_NORMAL,
		msc_fontSize,
		L"", //locale
		&g_write_format
	);

	if (!SUCCEEDED(hr)) {
		return 0;
	}

	hr = g_render_target->CreateSolidColorBrush(D2D1::ColorF(D2D1::ColorF::White), &g_text_brush);
	if (!SUCCEEDED(hr)) {
		return 0;
	}

	// Center the text horizontally and vertically.
	g_write_format->SetTextAlignment(DWRITE_TEXT_ALIGNMENT_LEADING);
	g_write_format->SetParagraphAlignment(DWRITE_PARAGRAPH_ALIGNMENT_NEAR);

	g_hwnd = hwnd;
	return 1;
}

void render_begin() {
	if (!g_hwnd) {
		return;
	}

	g_render_target->BeginDraw();
	g_render_target->Clear(D2D1::ColorF(D2D1::ColorF::Black));
}

void render_draw_box(int x, int y, int width, int height, int fill_color) {
	if (!g_hwnd) {
		return;
	}

	g_render_target->DrawRectangle(D2D1::RectF((float)x, (float)y, (float)(x + width), (float)(y + height)), g_box_outlie_brush);
	if (fill_color >= 0 && fill_color < MAX_BOX_BLUSH) {
		ID2D1SolidColorBrush* brush = g_box_solid_brushs[fill_color];
		g_render_target->FillRectangle(D2D1::RectF((float)x, (float)y, (float)(x + width), (float)(y + height)), brush);
	}
}

void render_draw_text(int x, int y, const char* text) {
	if (!g_hwnd) {
		return;
	}

	WCHAR* ws = NULL;
	WCHAR stack_ws[MAX_TEXT_STACK_BUFFER] = {};
	size_t sz = strlen(text) + 1;
	if (sz > MAX_TEXT_STACK_BUFFER) {
		if (!g_wchar_buffer.buffer) {
			g_wchar_buffer.buffer = (WCHAR*)malloc(sz * sizeof(WCHAR));
			g_wchar_buffer.size = sz;
		}
		else {
			if (g_wchar_buffer.size >= sz) {
				ZeroMemory(g_wchar_buffer.buffer, g_wchar_buffer.size * sizeof(WCHAR));
			}
			else {
				free(g_wchar_buffer.buffer);
				g_wchar_buffer.buffer = (WCHAR*)malloc(sz * sizeof(WCHAR));
				g_wchar_buffer.size = sz;
			}
		}

		mbstowcs(g_wchar_buffer.buffer, text, sz);
		ws = g_wchar_buffer.buffer;
	}
	else {
		mbstowcs(stack_ws, text, sz);
		ws = stack_ws;
	}

	// Retrieve the size of the render target.
	D2D1_SIZE_F rt_sz = g_render_target->GetSize();
	g_render_target->DrawText(
		ws,
		sz - 1,
		g_write_format,
		D2D1::RectF((float)x, (float)y, rt_sz.width, rt_sz.height),
		g_text_brush
	);
}

void render_end() {
	if (!g_hwnd) {
		return;
	}

	g_render_target->EndDraw();
}

int render_destroy() {
	if (!g_hwnd) {
		return 1;
	}

	if (g_wchar_buffer.buffer) {
		free(g_wchar_buffer.buffer);
		g_wchar_buffer.size = 0;
	}

	g_write_format->Release();
	g_write_format = NULL;

	g_write_factory->Release();
	g_write_factory = NULL;

	for (int i = 0; i < MAX_BOX_BLUSH; i++) {
		g_box_solid_brushs[i]->Release();
		g_box_solid_brushs[i] = NULL;
	}

	g_box_outlie_brush->Release();
	g_box_outlie_brush = NULL;

	g_render_target->Release();
	g_render_target = NULL;

	g_d2d_factory->Release();
	g_d2d_factory = NULL;

	return 1;
}
