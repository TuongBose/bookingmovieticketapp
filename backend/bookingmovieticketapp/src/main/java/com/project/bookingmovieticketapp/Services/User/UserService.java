package com.project.bookingmovieticketapp.Services.User;

import com.project.bookingmovieticketapp.DTOs.UserDTO;
import com.project.bookingmovieticketapp.Models.User;
import com.project.bookingmovieticketapp.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class UserService implements IUserService {
    private final UserRepository userRepository;

    @Override
    public User createUser(UserDTO userDTO) throws Exception {
        String phoneNumber = userDTO.getPhonenumber();
        if (userRepository.existsByphonenumber(phoneNumber))
            throw new RuntimeException("So dien thoai nay da ton tai");

        User newUser = User
                .builder()
                .name(userDTO.getName())
                .email(userDTO.getEmail())
                .password(userDTO.getPassword())
                .phonenumber(userDTO.getPhonenumber())
                .dateofbirth(userDTO.getDateofbirth())
                .isactive(true)
                .rolename(false)
                .build();
        return userRepository.save(newUser);
    }

    @Override
    public User loginCustomer(String phoneNumber, String password) throws Exception {
        Optional<User> userOptional = userRepository.findByphonenumber(phoneNumber);
        if (userOptional.isEmpty())
            throw new RuntimeException("Sai so dien thoai hoac password");

        User existingUser = userOptional.get();
        if (!existingUser.isIsactive()) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }

        if (!existingUser.getPassword().equals(password)) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }

        if (existingUser.isRolename()) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }

        return existingUser;
    }

    @Override
    public User loginAdmin(String phoneNumber, String password) throws Exception {
        Optional<User> userOptional = userRepository.findByphonenumber(phoneNumber);
        if (userOptional.isEmpty())
            throw new RuntimeException("Sai so dien thoai hoac password");

        User existingUser = userOptional.get();
        if (!existingUser.isIsactive()) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }

        if (!existingUser.getPassword().equals(password)) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }
        if (!existingUser.isRolename()) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }

        return existingUser;
    }

    @Override
    public List<User> getAllUserCustomer() {
        return userRepository.findByRolenameFalse();
    }

    @Override
    public List<User> getAllUserAdmin() {
        return userRepository.findByRolenameTrue();
    }

    @Override
    public User updateUserStatus(int userId, boolean isActive) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            throw new RuntimeException("Không tìm thấy người dùng với ID: " + userId);
        }
        User user = userOptional.get();
        user.setIsactive(isActive);
        return userRepository.save(user);
    }

    @Override
    public User getUserById(int id) throws Exception {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + id));
    }

    @Override
    public void saveUser(User user) {
        userRepository.save(user);
    }

    @Override
    public User updateUser(int id, UserDTO userDTO) {
        User existingUser = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay UserId"));

        existingUser.setName(userDTO.getName());
        existingUser.setEmail(userDTO.getEmail());
        existingUser.setPassword(userDTO.getPassword());
        existingUser.setAddress(userDTO.getAddress());
        existingUser.setPhonenumber(userDTO.getPhonenumber());
        existingUser.setDateofbirth(userDTO.getDateofbirth());

        userRepository.save(existingUser);
        return existingUser;
    }

    @Override
    public boolean checkExistsByphonenumber(String phoneNumber) {
        Optional<User> userOptional = userRepository.findByphonenumber(phoneNumber);
        if (userOptional.isEmpty())
            return userRepository.existsByphonenumber(phoneNumber);

        User existingUser = userOptional.get();
        if (existingUser.isRolename()) {
            return true;
        }
        return existingUser.isIsactive();
    }

    @Override
    public boolean checkDoesNotExistsByphonenumber(String phoneNumber) {
        Optional<User> userOptional = userRepository.findByphonenumber(phoneNumber);
        if (userOptional.isEmpty()) return true;

        User existingUser = userOptional.get();
        if (existingUser.isRolename()) return true;
        return !existingUser.isIsactive();
    }

    @Override
    public User resetPassword(String phoneNumber, String password) throws Exception {
        Optional<User> userOptional = userRepository.findByphonenumber(phoneNumber);
        if (userOptional.isEmpty())
            throw new RuntimeException("Số điện thoại này không tồn tại");

        User existingUser = userOptional.get();
        existingUser.setPassword(password);
        userRepository.save(existingUser);
        return existingUser;
    }
}
