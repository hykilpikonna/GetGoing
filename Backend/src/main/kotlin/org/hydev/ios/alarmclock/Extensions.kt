package org.hydev.ios.alarmclock

import org.springframework.http.ResponseEntity

fun bad(msg: String): ResponseEntity<String> = ResponseEntity.badRequest().body(msg)
