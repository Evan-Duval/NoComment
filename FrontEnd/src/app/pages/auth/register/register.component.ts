import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule, AbstractControl, ValidationErrors } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../../services/auth.service';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { IUser } from '../../../interfaces/iuser';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule, CommonModule],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent {
  registerForm: FormGroup;

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private http: HttpClient
  ) {
    this.registerForm = this.formBuilder.group({
      first_name: [null, Validators.required],
      last_name: [null, Validators.required],
      email: [null, [Validators.required, Validators.email]],
      birthday: [null, Validators.required],
      password: [null, [Validators.required, Validators.minLength(12)]],
      c_password: [null, [Validators.required, Validators.minLength(12)]],
      username: [null, Validators.required]
    }, {
      validators: this.passwordMatchValidator
    });
  }

  // Validateur personnalisé pour vérifier si les mots de passe correspondent
  passwordMatchValidator(control: AbstractControl): ValidationErrors | null {
    const password = control.get('password')?.value;
    const confirmPassword = control.get('c_password')?.value;
    
    if (password !== confirmPassword && password && confirmPassword) {
      control.get('c_password')?.setErrors({ passwordMismatch: true });
      return { passwordMismatch: true };
    }
    
    return null;
  }

  onSubmit(): void {
    if (this.registerForm.valid) {
      const formValues = this.registerForm.value;
      const birthday = new Date(formValues.birthday);

      // Format the birthday to YYYY-MM-DD
      const formattedBirthday = birthday.toISOString().split('T')[0];

      const userData: IUser = {
        first_name: formValues.first_name,
        last_name: formValues.last_name,
        email: formValues.email,
        birthday: formattedBirthday,
        password: formValues.password,
        c_password: formValues.c_password,
        username: formValues.username,
        rank: 'user',
        logo: 'default_logo.png',
        bio: 'Je suis un Nouvel Utilisateur sur NoComment',
        certified: false,
      };
      
      const newUser = this.authService.createUser(userData);
      
      this.authService.register(userData).subscribe({
        next: (response) => {
          console.log('Inscription réussie', response);
          localStorage.setItem('token', response.accessToken);
        },
        error: (error) => {
          console.error('Erreur d\'inscription', error);
        },
      });
    }
  }
}
