fun main() 
{
    print("Enter a number of sequence: ")
    val num = readLine()!!.toInt()

    var nums = 0
    var numero = 1

    println("Result:")

    for (i in 0 until num) 
    {
        println(nums)
        val next = nums + numero
        nums = numero
        numero = next
    }
}