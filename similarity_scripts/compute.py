#!/usr/bin/env python

from outputSample import dataset
from math import sqrt
 

def pearson_correlation(person1,person2):
 
     # To get both rated items
     both_rated = {}
     for item in dataset[person1]:
        if item in dataset[person2]:
          both_rated[item] = 1
 
     number_of_ratings = len(both_rated) 
 
     # Checking for number of ratings in common
     if number_of_ratings == 0:
         return 0
 
     # Add up all the preferences of each user
     person1_preferences_sum = sum([int(dataset[person1][item]) for item in both_rated])
     person2_preferences_sum = sum([int(dataset[person2][item]) for item in both_rated])
 
     # Sum up the squares of preferences of each user
     person1_square_preferences_sum = sum([pow(int(dataset[person1][item]),2) for item in both_rated])
     person2_square_preferences_sum = sum([pow(int(dataset[person2][item]),2) for item in both_rated])
 
    # Sum up the product value of both preferences for each item
     product_sum_of_both_users = sum([int(dataset[person1][item]) * int(dataset[person2][item]) for item in both_rated])
 
   # Calculate the pearson score
     numerator_value = product_sum_of_both_users - (person1_preferences_sum*person2_preferences_sum/number_of_ratings)
     denominator_value = sqrt((person1_square_preferences_sum - pow(person1_preferences_sum,2)/number_of_ratings) * (person2_square_preferences_sum -pow(person2_preferences_sum,2)/number_of_ratings))
     if denominator_value == 0:
       return 0
     else:
       r = numerator_value/denominator_value
     return r 
 
#print pearson_correlation('2579197','1012786','804934')
#print dataset.get('804934')

userf = open('similarity.py', 'a')
#wf.write(str(outerDict))
count =0
users = dataset.keys()
print "len of users {}",len(users)
for user in users:
  userDict={}
  partDict={}
  count = count+1
  if(count%100 == 0):
    print count
  for partner in users:
    if partner == user:
      continue
    sim = pearson_correlation(user,partner)
    if sim != 0:
      partDict[partner] = sim
    
  userDict[user]=partDict
  userf.write(str(userDict))
