package org.hydev.ios.alarmclock.data

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

/**
 * TODO: Write a description for this class!
 *
 * @author HyDEV Team (https://github.com/HyDevelop)
 * @author Hykilpikonna (https://github.com/hykilpikonna)
 * @author Vanilla (https://github.com/VergeDX)
 * @since 2021-01-12 09:28
 */
@RestController
@RequestMapping("/api")
class Test
{
    @GetMapping("/echo")
    fun echo(message: String?) = message
}
