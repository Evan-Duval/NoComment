import { IUser } from "../interfaces/iuser";

export class User implements IUser {
    constructor(
      public id: number | null,
      public first_name: string,
      public last_name: string,
      public email: string,
      public birthday: Date,
      public password: string,
      public c_password: string,
      public username: string,
      public rank: string,
      public logo: string,
      public bio: string,
      public certified: boolean
    ) {}

    getId(): number | null { return this.id; }
    getFirstName(): string { return this.first_name; }
    getLastName(): string { return this.last_name; }
    getEmail(): string { return this.email; }
    getBirthday(): Date { return this.birthday; }
    getPassword(): string { return this.password; }
    getCPassword(): string { return this.c_password; }
    getUsername(): string { return this.username; }
    getRank(): string { return this.rank; }
    getLogo(): string { return this.logo; }
    getBio(): string { return this.bio; }
    isCertified(): boolean { return this.certified; }
    
}
