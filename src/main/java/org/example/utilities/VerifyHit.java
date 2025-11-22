package org.example.utilities;

import java.io.InvalidClassException;
import java.math.BigDecimal;
import java.util.Set;

public class VerifyHit {



    public void validate(BigDecimal x , BigDecimal y , BigDecimal r) throws InvalidClassException {
        if (r.compareTo(BigDecimal.valueOf(2)) < 0 || r.compareTo(BigDecimal.valueOf(5)) > 0) {
            throw new InvalidClassException("Value r out of range [2,5]");
        }
        if (y.compareTo(BigDecimal.valueOf(-5)) < 0 || y.compareTo(BigDecimal.valueOf(5)) > 0) {
            throw new InvalidClassException("Value y out of range [-5,5]");
        }
        Set<BigDecimal> validX = Set.of(
                BigDecimal.valueOf(-4),
                BigDecimal.valueOf(-3), BigDecimal.valueOf(-2), BigDecimal.valueOf(-1),
                BigDecimal.ZERO,
                BigDecimal.ONE, BigDecimal.valueOf(2), BigDecimal.valueOf(3), BigDecimal.valueOf(4)
        );

        if (!validX.contains(x)) {
            throw new InvalidClassException("Value x out of range {-3,-2,-1,0,1,2,3}");
        }

    }

    public Boolean pointchecker(BigDecimal x, BigDecimal y, BigDecimal r) {
        Boolean fq =    x.compareTo(BigDecimal.ZERO) >=0 &&
                y.compareTo(BigDecimal.ZERO) >=0 &&
                r.compareTo(x)>=0 && (r.divide(new BigDecimal(2))).compareTo(y)>=0;
        Boolean sq =    x.compareTo(BigDecimal.ZERO) <= 0 &&
                y.compareTo(BigDecimal.ZERO) >= 0 &&
                y.compareTo(r.add(x.multiply(new BigDecimal("2")))) <= 0 ;
        Boolean tq =    x.compareTo(BigDecimal.ZERO)  >= 0 &&
                y.compareTo(BigDecimal.ZERO) <= 0 &&
                BigDecimal.valueOf(Math.pow(x.pow(2).add(y.pow(2)).doubleValue(), 0.5)).compareTo(r) <= 0 ;

        return fq || sq || tq;
    }


}

