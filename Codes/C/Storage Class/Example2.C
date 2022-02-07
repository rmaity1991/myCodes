/*
- Use static storage class only if you want the value of a
variable to persist between different function calls.

− Use register storage class for only those variables that are
being used very often in a program. Reason is, there are very
few CPU registers at our disposal and many of them might be
busy doing something else. Make careful utilization of the
scarce resources. A typical application of register storage class
is loop counters, which get used a number of times in a
program.

− Use extern storage class for only those variables that are being
used by almost all the functions in the program. This would
avoid unnecessary passing of these variables as arguments
when making a function call. Declaring all the variables as
extern would amount to a lot of wastage of memory space
because these variables would remain active throughout the
life of the program.

− If you don’t have any of the express needs mentioned above,
then use the auto storage class. In fact most of the times we
end up using the auto variables, because often it so happens
that once we have used the variables in a function we don’t
mind loosing them

*/