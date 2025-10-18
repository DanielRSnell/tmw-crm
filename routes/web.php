<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// Diagnostic route to check HTTPS detection
Route::get('/https-debug', function () {
    return response()->json([
        'APP_URL' => config('app.url'),
        'APP_ENV' => config('app.env'),
        'APP_FORCE_HTTPS' => config('app.force_https'),
        'ASSET_URL' => config('app.asset_url'),
        'url_to_root' => url()->to('/'),
        'asset_test' => asset('test.js'),
        'request_scheme' => request()->getScheme(),
        'request_secure' => request()->secure(),
        'server_https' => request()->server('HTTPS'),
        'server_http_host' => request()->server('HTTP_HOST'),
        'server_x_forwarded_proto' => request()->server('HTTP_X_FORWARDED_PROTO'),
    ]);
});
