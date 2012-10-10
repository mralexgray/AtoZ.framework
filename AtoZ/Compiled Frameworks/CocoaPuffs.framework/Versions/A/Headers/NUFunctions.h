/**
 
 \file      NUFunctions.h
 
 \brief     Adds a number of useful C functions.
 
 \details   At the moment the number of functions is small but their numbers
            should grow in time.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

/// ----------------------------------------------------------------------------
/// # Math Functions
/// ----------------------------------------------------------------------------

/**
 
 fclamp
 
 \brief  Returns value clamped within the lower and upper bounds.
 
 \details The return value is guaranteed to be greater or equal to the lower bound
 and less or equal to the upper bound.
 
 \param  in  lower  lower bound of the clamping range.
 \param  in  value  value to be clamped.
 \param  in  upper  upper bound of the clamping range.
 
 \return a clamped value.
 
 */
double fclamp(double lower, double value, double upper);

