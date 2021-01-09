package org.hydev.ios.alarmclock

import org.springframework.http.ResponseEntity
import java.security.SecureRandom
import javax.crypto.SecretKeyFactory

import javax.crypto.spec.PBEKeySpec

import java.security.spec.KeySpec
import java.util.*

/**
 * Generate "Bad Request" response entity
 *
 * @param msg Message
 * @return Response entity
 */
fun bad(msg: String): ResponseEntity<String> = ResponseEntity.badRequest().body(msg)

/**
 * Generate random salt
 *
 * @param len Length of the salt in bytes
 * @return Random byte array of size len
 */
fun randSalt(len: Int = 16): ByteArray
{
    val random = SecureRandom()
    val salt = ByteArray(16)
    random.nextBytes(salt)
    return salt
}

/**
 * Hash a password
 *
 * @return <Hash, Salt>
 */
fun String.passwordHash(salt: String = randSalt().base64): Pair<String, String>
{
    val spec: KeySpec = PBEKeySpec(toCharArray(), salt.base64, 32767, 512)
    val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1")
    return Pair(factory.generateSecret(spec).encoded.base64, salt)
}

val ByteArray.base64: String
    get() = Base64.getEncoder().encodeToString(this)

val String.base64: ByteArray
    get() = Base64.getDecoder().decode(this)


fun main(args: Array<String>)
{
    val (hash, salt) = "password".passwordHash()
    println(hash)
    val (hash2, salt2) = "password".passwordHash(salt)
    assert(hash == hash2 && salt == salt2)
    println("Hash matches")
}
