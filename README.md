# World Value Survey Linear Model Comparisons
This is an assignment that was given to me in my data mining class where we were tasked to investigate data regarding responses from US citizens for the World Value Survey. The survey includes over 250 questions ranging from religion to financial well-being.

I utilized RStudio to create predictive models on how satisfied individuals are in their life based on responses to other questions in the survey. Not only will this be helpful in predicting others happiness based on different information, but we can discover what information correlates with happiness.

For the purpose of this read me I will be highlighting some general information regarding the variables used. Then I will explain the different linear models made and show the accuracies of the models.

### Dependent and Indepent Variables 
Question V23 is asking individuals how satisfied they are with their life and will be acting as my dependent variable. The following questions were used as my independent variables:
- V55 references the freedom of choice and control you have on how your life turns out.
- V56 references whether you would believe that people would take advantage of you given the chance or would they be fair.
- V59 references your satisfaction with the financial situation of your household.
- V102 references how much you trust your family.
- V152 references religion and how important God is in your life.
- V238 references what economic class you consider yourself apart of.
- V240 references what sex the respondent is.

### Investigating Variables
The distribution of responses for V55(freedom of choice) where 10 is "a great deal of choice" and 1 is "no choice at all":
![V55Bar](Images/V55Bar.png)

The distribution of responses for V56(if people are fair) where 10 is "people would try to be fair" and 1 is "people would try to take advantage of you":
![V56Bar](Images/V56Bar.png)

The distribution of responses for V59(financial satisfaction) where 10 is "completely satisfied" and 1 is "completely dissatisfied":
![V59Bar](Images/V59Bar.png)

The distribution of responses for V102(family trust) where 1 is "trust completely" and 4 is "do not trust at all":
![V102Bar](Images/V102Bar.png)

The distribution of responses for V152(importance of religion) where 10 is "very important" and 1 is "not at all important":
![V152Bar](Images/V152Bar.png)

The distribution of responses for V238(economic class) where 1 is "upper class", 2 is "upper middle class", 3 is "lower middle class", 4 is "working class", and 5 is "lower class":
![V238Bar](Images/V238Bar.png)

The distribution of responses for V240(gender) where 0 is "female" and 1 is "male":
![V240DummyBar](Images/V240DummyBar.png)

