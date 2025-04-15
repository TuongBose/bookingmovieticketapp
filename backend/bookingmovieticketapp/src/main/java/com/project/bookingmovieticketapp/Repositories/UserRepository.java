package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User,Integer> {
    boolean existsByphonenumber(String phoneNumber);
    Optional<User> findByphonenumber(String phoneNumber);
}
