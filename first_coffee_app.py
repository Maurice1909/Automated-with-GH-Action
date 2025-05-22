print("Hello and Welcome to BIG MO's Coffee Shop")

name = input("May I take your name?\n")

menu = {
    "Latte": 7,
    "Cappuccino": 6,
    "Espresso": 4,
}

basket = []

def display_menu():
    print("Here's our menu:")
    for item in menu:
        print(f"{item} - £{menu[item]}")

def add_to_basket(item, quantity):
    if item in menu:
        basket.append((item, quantity))
        print(f"Added {quantity} x {item} to your basket.")
    else:
        print("Sorry, we don't sell that here.")

def view_basket():
    if not basket:
        print("Your basket is empty.")
    else:
        print("Your basket contains:")
        for item, quantity in basket:
            print(f"{quantity} x {item}")

def remove_from_basket(item):
    for i in range(len(basket)):
        if basket[i][0] == item:
            del basket[i]
            print(f"Removed {item} from your basket.")
            return
    print(f"{item} is not in your basket.")

while True:
    display_menu()
    action = input("\nWhat would you like to do? (add/view/remove/checkout/exit)\n").lower()
    
    if action == "add":
        order = input("What would you like to order?\n").title()
        if order in menu:
            try:
                quantity = int(input("How many would you like?\n"))
                add_to_basket(order, quantity)
            except ValueError:
                print("Please enter a number")
        else:
            print("Item not found in menu.")

    elif action == "view":
        view_basket()

    elif action == "remove":
        item_to_remove = input("Which item would you like to remove from your basket?\n")
        remove_from_basket(item_to_remove)

    elif action == "checkout":
        total_cost = sum(menu[item] * quantity for item, quantity in basket)
        print(f"Your total is £{total_cost}. Thank you for your order!")
        break

    elif action == "exit":
        print("Thank you for visiting BIG MO's Coffee Shop!")
        break

    else:
        print("Invalid option. Please try again.")

