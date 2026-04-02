fun main() 
{
    print("Enter some numbers (separated by space): ")
    val inputLine = readLine()!!

    val numbers = inputLine.split(" ")
        .mapNotNull { it.toIntOrNull() }

    if (numbers.isEmpty()) 
    {
        println("No valid numbers entered.")
        return
    }

    val min = numbers.minOrNull()
    val max = numbers.maxOrNull()

    println("\nThe highest is: $max")
    println("The lowest is: $min")
}