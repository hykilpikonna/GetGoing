package org.hydev.ios.alarmclock.data

import org.hydev.ios.alarmclock.bad
import org.hydev.ios.alarmclock.passwordHash
import org.springframework.data.domain.Example
import org.springframework.data.domain.ExampleMatcher
import org.springframework.data.domain.ExampleMatcher.GenericPropertyMatchers.ignoreCase
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import javax.persistence.*
import javax.validation.constraints.Email
import javax.validation.constraints.NotNull

/**
 * The database model for an user
 *
 * @author HyDEV Team (https://github.com/HyDevelop)
 * @author Hykilpikonna (https://github.com/hykilpikonna)
 * @author Vanilla (https://github.com/VergeDX)
 * @since 2021-01-09 10:48
 */
@Entity
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0,

    @NotNull @Column(length = 32)
    var name: String,

    @NotNull @Column(length = 100)
    var passHash: String,

    @NotNull @Column(length = 32)
    var passSalt: String
)
{
    constructor(name: String, pass: String) : this(name=name, passHash="", passSalt="")
    {
        val (h, s) = pass.passwordHash()
        passHash = h
        passSalt = s
    }
}

interface UserRepo: JpaRepository<User, Long>

@RestController
@RequestMapping("/api/user")
class UserApi(val repo: UserRepo)
{
    val em = ExampleMatcher.matching().withIgnorePaths("id", "passHash", "passSalt").withMatcher("name", ignoreCase())

    @GetMapping("/register")
    fun register(@RequestParam name: String, @RequestParam pass: String): Any
    {
        // Check username length
        if (name.length !in 3..32) return bad("Username length not in range 3 to 32")

        // Check if username exists
        val user = User(name, pass)
        if (repo.exists(Example.of(user, em))) return bad("Username has already been used")

        // Check password strength
        if (pass.length < 8) return bad("Password must be longer than 8 chars")

        // Register
        repo.save(user)
        return user
    }
}
