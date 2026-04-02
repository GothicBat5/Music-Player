def kg_to_lbs(kg):
    return kg * 2.20462

def lbs_to_kg(lbs):
    return lbs / 2.20462

print("Converter.")
print("Input [Kg] [Lbs]\n")
choice = input("Choice: ").strip().lower()

if choice == "kg": 
    try:
        kg_value = float(input("\nEnter Kg: "))
        pounds = kg_to_lbs(kg_value)
        print(f"\n{kg_value} Kg is {pounds:.2f} Lbs. \n")
    except ValueError:
        print("Invalid Input")

elif choice == "lbs":
    try:
        lbs_value = float(input("\nEnter Lbs: "))
        kilograms = lbs_to_kg(lbs_value)
        print(f"\n{lbs_value} Lbs is {kilograms:.2f} Kg. \n")
    except ValueError:
        print("Invalid Input")

else:
    print("Invalid Input")
