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

    @NotNull @Column(length = 256)
    var email: String,

    @NotNull @Column(length = 100)
    var passHash: String = "",

    @NotNull @Column(length = 32)
    var passSalt: String = ""
)
{
    constructor(name: String, email: String, pass: String) : this(name = name, email = email)
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
    val em = ExampleMatcher.matching().withIgnorePaths("id", "passHash", "passSalt", "name").withMatcher("email", ignoreCase())

    @GetMapping("/register")
    fun register(@RequestParam name: String, @RequestParam pass: String, @RequestParam @Email email: String): Any
    {
        // Check name length
        if (name.length !in 1..32) return bad("Name length not in range 1 to 32")

        // Check if email exists
        val user = User(name, email, pass)
        if (repo.exists(Example.of(user, em))) return bad("Email is already registered")

        // Check password strength
        if (pass.length < 8) return bad("Password must be longer than 8 chars")

        // Register
        repo.save(user)
        return user
    }

    @GetMapping("/delete")
    fun delete(@RequestParam email: String, @RequestParam pass: String): Any
    {
        // Check if username exists
        val users = repo.findAll(Example.of(User("", email, pass), em))
        if (users.isEmpty()) return bad("User doesn't exist")

        // Delete
        users.forEach { repo.delete(it) }
        return "Deleted"
    }
}
