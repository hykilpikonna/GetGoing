package org.hydev.ios.alarmclock

import org.hydev.ios.alarmclock.data.UserRepo
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories

@SpringBootApplication
@EnableMongoRepositories(basePackageClasses = [UserRepo::class])
class AlarmClockApplication

fun main(args: Array<String>)
{
    runApplication<AlarmClockApplication>(*args)
}
