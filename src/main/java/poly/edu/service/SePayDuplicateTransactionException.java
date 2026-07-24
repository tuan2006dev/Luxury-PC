package poly.edu.service;

public class SePayDuplicateTransactionException extends RuntimeException {

    public SePayDuplicateTransactionException() {
        super("Duplicate SePay transaction");
    }
}
