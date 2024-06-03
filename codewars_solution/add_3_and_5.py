#a program to find the multiple of 3 and 5 in the range of a certain postive number n 
# and it returns  0 if the number is negetive  
# we run into a problem here because we might have to  count the multiple 15 and we do not understand that 

def multiple_finder(n):

    number_list = []
    if n < 0 :
        print(f'{n} is less than 0')
        return 0
    for i in range (1,n+1):
        if i %3 ==0 or i % 5 == 0 :
            print(i)
            number_list.append(i)
    return sum(number_list)

print(multiple_finder(6))