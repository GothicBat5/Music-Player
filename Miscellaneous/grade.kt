fun main() 
{
    val students = mutableMapOf<String, Int>()

    println("Student Grading System")
    println("Type 'done' when finished.\n")

    while (true) 
    {
        print("Enter student name: ")
        val name = readLine()!!.trim()

        if (name.lowercase() == "done") break

        print("Enter score [0-100]: ")
        val scoreInput = readLine()

        val score = scoreInput?.toIntOrNull()

        if (score != null && score in 0..100) 
        {
            students[name] = score
        } 
        
        else 
        {
            println("Invalid score.\n")
        }
    }

    println("\n=== Results ===")
    for ((name, score) in students)
    {
        val result = if (score >= 75) "PASSED" else "FAILED"
        println("$name: $result")
    }
}