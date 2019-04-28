<?php

if ( isset( $_GET['path'] ) ) {
	$path = $_GET['path'];
	$path = preg_replace( '/[\x00-\x1F\x7F?&#]/', '', $path );
} else {
	$path = '/';
}

header( 'HTTP/1.1 302 Found' );
header( "Location: https://codex.wordpress.org$path" );
